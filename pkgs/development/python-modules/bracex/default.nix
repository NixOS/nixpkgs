{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AfcVzQ7XpiLsizIyLnFYE/dXTeUx8Jtw9vOywQ9oJCU=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bracex" ];

  meta = with lib; {
    description = "Bash style brace expansion for Python";
    homepage = "https://github.com/facelessuser/bracex";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
