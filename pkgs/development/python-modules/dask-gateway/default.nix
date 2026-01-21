{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  dask,
  distributed,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dask-gateway";
  # update dask-gateway lock step with dask-gateway-server
  version = "2025.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-gateway";
    tag = version;
    hash = "sha256-Ezt5QkA21SDfuCMm+XY8d+xso8SDb4lmK/yd89Guu0Y=";
  };

  sourceRoot = "${src.name}/dask-gateway";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
