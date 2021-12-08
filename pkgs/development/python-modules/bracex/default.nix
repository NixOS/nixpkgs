{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.2.1";

  src = fetchFromGitHub {
     owner = "facelessuser";
     repo = "bracex";
     rev = "2.2.1";
     sha256 = "12894hxf9gr5v209xrrzz0rax3bb61q3pxqikppfnzn7b0q1mklk";
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
