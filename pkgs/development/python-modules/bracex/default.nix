{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8230f3a03f1f76c192a7844377124300fbaec83870a728b629dfabd9be9e83d0";
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
