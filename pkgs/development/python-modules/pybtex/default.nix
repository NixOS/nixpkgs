{ stdenv, buildPythonPackage, fetchPypi, latexcodec, pyyaml }:

buildPythonPackage rec {
  version = "0.23.0";
  pname = "pybtex";

  doCheck = false;
  propagatedBuildInputs = [ latexcodec pyyaml ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "b92be18ccd5e9a37895949dcf359a1f6890246b73646dddf1129178ee12e4bef";
  };

  meta = {
    homepage = "https://pybtex.org/";
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = stdenv.lib.licenses.mit;
  };
}
