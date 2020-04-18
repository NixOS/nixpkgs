{ stdenv, buildPythonPackage, fetchPypi, latexcodec, pyyaml }:

buildPythonPackage rec {
  version = "0.22.2";
  pname = "pybtex";

  doCheck = false;
  propagatedBuildInputs = [ latexcodec pyyaml ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "00816e5f8570609d8ce3360cd23916bd3e50428a3508127578fdb4dc2b731c1c";
  };

  meta = {
    homepage = "https://pybtex.org/";
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = stdenv.lib.licenses.mit;
  };
}
