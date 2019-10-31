{ stdenv, fetchPypi, buildPythonPackage, astunparse }:

buildPythonPackage rec {
  pname = "gast";
  version =  "0.3.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "5c7617f1f6c8b8b426819642b16b9016727ddaecd16af9a07753e537eba8a3a5";
  };
  checkInputs = [ astunparse ] ;
  meta = with stdenv.lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
