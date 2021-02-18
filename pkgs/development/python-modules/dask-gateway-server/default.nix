{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, colorlog
, cryptography
, traitlets
, go
, isPy27
}:

buildPythonPackage rec {
  pname = "dask-gateway-server";
  # update dask-gateway-server lock step with dask-gateway
  version = "0.9.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "82bca8a98fc1dbda9f67c8eceac59cb92abe07db6227c120a1eb1d040ea40fda";
  };

  nativeBuildInputs = [
    go
  ];

  propagatedBuildInputs = [
    aiohttp
    colorlog
    cryptography
    traitlets
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    export GO111MODULE=off
  '';

  # tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [ "dask_gateway_server" ];

  meta = with lib; {
    description = "A multi-tenant server for securely deploying and managing multiple Dask clusters";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
