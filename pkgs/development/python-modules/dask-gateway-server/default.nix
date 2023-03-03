{ lib
, aiohttp
, buildPythonPackage
, colorlog
, cryptography
, fetchFromGitHub
, go
, pythonOlder
, traitlets
}:

buildPythonPackage rec {
  pname = "dask-gateway-server";
  # update dask-gateway-server lock step with dask-gateway
  version = "2022.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-gateway";
    rev = version;
    hash = "sha256-Grjp7gt3Pos4cQSGV/Rynz6W/zebRI0OqDiWT4cTh8I=";
  };

  sourceRoot = "${src.name}/${pname}";

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

  # Tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [
    "dask_gateway_server"
  ];

  meta = with lib; {
    description = "A multi-tenant server for securely deploying and managing multiple Dask clusters";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
