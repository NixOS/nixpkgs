{ lib, fetchPypi, buildPythonPackage, astunparse }:

buildPythonPackage rec {
  pname = "gast";
  version =  "0.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "8109cbe7aa0f7bf7e4348379da05b8137ea1f059f073332c3c1cedd57db8541f";
  };
  checkInputs = [ astunparse ] ;
  meta = with lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
