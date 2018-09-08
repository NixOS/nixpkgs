{ stdenv, buildPythonPackage, fetchPypi, docutils, pybtex, six }:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "pybtex-docutils";

  doCheck = false;
  buildInputs = [ docutils pybtex six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dqk4lplij7rbqqi4dbpw3wzr4wj08ysswvdibls6s0x3ij7bc74";
  };

  meta = {
    description = "A docutils backend for pybtex";
    homepage = https://github.com/mcmtroffaes/pybtex-docutils;
    license = stdenv.lib.licenses.mit;
  };
}
