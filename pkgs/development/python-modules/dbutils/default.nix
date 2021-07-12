{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "sha256-Vw590TbBMRb+74vKGGCeP2a4ZoqcPV8hCdh0TERE2GE=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
