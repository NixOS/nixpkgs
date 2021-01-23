{ stdenv, buildPythonPackage, fetchPypi, docutils, pybtex, six }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "pybtex-docutils";

  doCheck = false;
  buildInputs = [ docutils pybtex six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "cead6554b4af99c287dd29f38b1fa152c9542f56a51cb6cbc3997c95b2725b2e";
  };

  meta = {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = stdenv.lib.licenses.mit;
  };
}
