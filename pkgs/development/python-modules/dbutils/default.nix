{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "1cc8zyd4lapzf9ny6c2jf1vysphlhr19m8miyvw5spbyq4pxpnsf";
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
