{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  poetry-core,
  invoke,
  requests,
  pynetbox,
  paramiko,
  fastapi,
  starlette,
  uvicorn,
  websockets,
  jinja2,
  ujson,
  orjson,
  httpcore,
  netbox,
  proxmoxer,
  packaging,
}:
buildPythonPackage rec {
  pname = "netbox-proxbox";
  version = "0.0.5"; # incompatible with netbox 4.x, waiting for https://github.com/netdevopsbr/netbox-proxbox/issues/176
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netdevopsbr";
    repo = "netbox-proxbox";
    rev = "v${version}";
    hash = "sha256-DusIDNGvkzCO0a7QlTGQfZ2jjYN+yT0qp3WwB/eb1rY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    poetry-core
    invoke
    requests
    pynetbox
    paramiko
    fastapi
    starlette
    uvicorn
    websockets
    jinja2
    ujson
    orjson
    httpcore
    proxmoxer
    packaging
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_proxbox" ];

  meta = {
    description = "Netbox Plugin for integration between Proxmox and Netbox";
    homepage = "https://github.com/netdevopsbr/netbox-proxbox";
    changelog = "https://github.com/netdevopsbr/netbox-proxbox/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
