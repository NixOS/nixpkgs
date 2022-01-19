{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "fadeb979e1406dc123e2db9955f314e0d5360f304e0bd6cf047aaa5fc3fdf5b3";
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
