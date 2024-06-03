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
  version = "2023.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-gateway";
    rev = "refs/tags/${version}";
    hash = "sha256-+YCHIfNq8E2rXO8b91Q1D21dVzNWnJZIKZeY4AETa7s=";
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

  meta = with lib; {
    description = "A client library for interacting with a dask-gateway server";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
