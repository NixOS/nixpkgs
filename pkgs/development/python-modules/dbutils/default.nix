{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "6ec83f4d75d7a7b42a92e86b775f251e2671639b3b2123fe13a5d8d8fe7c5643";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dbutils" ];

  meta = with lib; {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
