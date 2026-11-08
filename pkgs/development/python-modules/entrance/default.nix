{
  lib,
  fetchPypi,
  buildPythonPackage,
  routerFeatures,
  hatchling,
  janus,
  ncclient,
  paramiko,
  pyyaml,
  websockets,
  ujson,
  fastapi,
  uvicorn,
}:

let
  # The `routerFeatures` flag optionally brings in some somewhat heavy
  # dependencies, in order to enable interacting with routers
  opts =
    if routerFeatures then
      {
        prePatch = "";
        extraBuildInputs = [
          janus
          ncclient
          paramiko
        ];
      }
    else
      {
        prePatch = "";
        extraBuildInputs = [ ];
      };
in

buildPythonPackage rec {
  pname = "entrance";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fr7ixTFA4N2nYFE2mmaAkmIAxFGfuF/Pou/DQYd1WyY=";
  };

  # The versions of `sanic` and `websockets` in nixpkgs only support 3.6 or later

  # No useful tests
  doCheck = false;

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    pyyaml
    ujson
    uvicorn
    websockets
  ]
  ++ opts.extraBuildInputs;

  prePatch = opts.prePatch;

  meta = {
    description = "Server framework for web apps with an Elm frontend";
    homepage = "https://github.com/ensoft/entrance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ simonchatts ];
  };
}
