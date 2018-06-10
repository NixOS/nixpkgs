{ stdenv, fetchPypi, buildPythonPackage, astunparse }:

buildPythonPackage rec {
  pname = "gast";
  version =  "0.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0c296xm1vz9x4w4inmdl0k8mnc0i9arw94si2i7pglpc461r0s3h";
  };
  checkInputs = [ astunparse ] ;
  meta = with stdenv.lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
