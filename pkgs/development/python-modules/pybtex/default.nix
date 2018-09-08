{ stdenv, buildPythonPackage, fetchPypi, latexcodec, pyyaml }:

buildPythonPackage rec {
  version = "0.21";
  pname = "pybtex";

  doCheck = false;
  propagatedBuildInputs = [ latexcodec pyyaml ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "00300j8dn5pxq4ndxmfmbmycg2znawkqs49val2x6jlmfiy6r2mg";
  };

  meta = {
    homepage = https://pybtex.org/;
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = stdenv.lib.licenses.mit;
  };
}
