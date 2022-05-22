{ lib
, buildPythonPackage
, click
, dask
, distributed
, fetchFromGitHub
, pythonOlder
, pyyaml
, tornado
}:

buildPythonPackage rec {
  pname = "dask-gateway";
  # update dask-gateway lock step with dask-gateway-server
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

  propagatedBuildInputs = [
    click
    dask
    distributed
    pyyaml
    tornado
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "click<8.1.0" "click"
  '';

  # Tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [
    "dask_gateway"
  ];

  meta = with lib; {
    description = "A client library for interacting with a dask-gateway server";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
