-include env
IMAGENAME := $(shell basename `git rev-parse --show-toplevel`)
NAMESPACE := werwolfby
SHA := $(shell git rev-parse --short HEAD)
timestamp := $(shell date +"%Y%m%d%H%M")


.PHONY: download echo build run stop start rmf rmi

download:
	#wget https://github.com/werwolfby/hardlinker/releases/download/$(HARDLINKER_VERSION)/hardlinker-$(HARDLINKER_VERSION).zip -O hardlinker.zip
	rm -R hardlinker || true
	mkdir hardlinker
	unzip hardlinker.zip -d hardlinker

echo:
	@echo "You can run 'build' to build image from the scratch"
	@echo ""
	@echo "Or you can copy 'env.template' to your 'env' and "
	@echo "change variables to values suitable for your system"


build:
	docker rmi -f $(NAMESPACE)/$(IMAGENAME):bak || true
	docker tag $(NAMESPACE)/$(IMAGENAME) $(NAMESPACE)/$(IMAGENAME):bak || true
	docker rmi -f $(NAMESPACE)/$(IMAGENAME) || true
	docker build -t $(NAMESPACE)/$(IMAGENAME) .


run:
	docker rm $(CONTAINER_NAME) || true
	docker run -d --name $(CONTAINER_NAME) $(PORTS) $(VOLUMES) $(ENVS) $(NAMESPACE)/$(IMAGENAME)


stop:
	docker stop $(CONTAINER_NAME)


start:
	docker start $(CONTAINER_NAME)


rmf:
	docker rm -f $(CONTAINER_NAME)


rmi:
	docker rmi $(NAMESPACE)/$(IMAGENAME)


rmibak:
	docker rmi $(NAMESPACE)/$(IMAGENAME):bak


tag:
	docker tag $(NAMESPACE)/$(IMAGENAME) $(NAMESPACE)/$(IMAGENAME):$(HARDLINKER_VERSION)


push:
	docker push $(NAMESPACE)/$(IMAGENAME)
