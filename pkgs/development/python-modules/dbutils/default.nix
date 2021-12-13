{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "549d472197b3eef27e7bb2dd2246b28e880ac0ae9fdf63aadfd3b7def153db0c";
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
