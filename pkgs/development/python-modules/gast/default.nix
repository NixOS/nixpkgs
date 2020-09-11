{ stdenv, fetchPypi, buildPythonPackage, astunparse }:

buildPythonPackage rec {
  pname = "gast";
  version =  "0.4.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "40feb7b8b8434785585ab224d1568b857edb18297e5a3047f1ba012bc83b42c1";
  };
  checkInputs = [ astunparse ] ;
  meta = with stdenv.lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
