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
  version = "0.8.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "272134933b7e2068cd89a17a5012c76a29fbd9e40a78164345a2b15353d4b40a";
  };

  nativeBuildInputs = [
    go
  ];

  requiredPythonModules = [
    aiohttp
    colorlog
    cryptography
    traitlets
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
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
