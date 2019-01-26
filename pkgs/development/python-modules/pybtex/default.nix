{ stdenv, buildPythonPackage, fetchPypi, latexcodec, pyyaml }:

buildPythonPackage rec {
  version = "0.22.0";
  pname = "pybtex";

  doCheck = false;
  propagatedBuildInputs = [ latexcodec pyyaml ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "0rprg7h12pv9rb6bi950mz1disc265sg5qcg34637ns1z74hxdr6";
  };

  meta = {
    homepage = "https://pybtex.org/";
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = stdenv.lib.licenses.mit;
  };
}
