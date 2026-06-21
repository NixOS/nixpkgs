{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  dask,
  distributed,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dask-gateway";
  # update dask-gateway lock step with dask-gateway-server
  version = "2026.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-gateway";
    tag = version;
    hash = "sha256-rSwGLJD5pGoYl4IIzBJ/hNxM+obE23VrYnrlQO1IBgw=";
  };

  sourceRoot = "${src.name}/dask-gateway";

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    dask
    distributed
  ];

  # tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [ "dask_gateway" ];

  meta = {
    description = "Client library for interacting with a dask-gateway server";
    homepage = "https://gateway.dask.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
