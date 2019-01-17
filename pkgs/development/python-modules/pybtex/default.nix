{ stdenv, buildPythonPackage, fetchPypi, latexcodec, pyyaml }:

buildPythonPackage rec {
  version = "0.22.1";
  pname = "pybtex";

  doCheck = false;
  propagatedBuildInputs = [ latexcodec pyyaml ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "bc6aaf8c5b56c9c5cfe34fd4171295c2b637193d2265b02c10db5608aec11aba";
  };

  meta = {
    homepage = "https://pybtex.org/";
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = stdenv.lib.licenses.mit;
  };
}
