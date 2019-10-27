{ stdenv, fetchPypi, buildPythonPackage, astunparse }:

buildPythonPackage rec {
  pname = "gast";
  version =  "0.2.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1w5dzdb3gpcfmd2s0b93d8gff40a1s41rv31458z14inb3s9v4zy";
  };
  checkInputs = [ astunparse ] ;
  meta = with stdenv.lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
