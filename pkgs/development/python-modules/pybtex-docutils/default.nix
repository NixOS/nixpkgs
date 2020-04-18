{ stdenv, buildPythonPackage, fetchPypi, docutils, pybtex, six }:

buildPythonPackage rec {
  version = "0.2.2";
  pname = "pybtex-docutils";

  doCheck = false;
  buildInputs = [ docutils pybtex six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea90935da188a0f4de2fe6b32930e185c33a0e306154322ccc12e519ebb5fa7d";
  };

  meta = {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = stdenv.lib.licenses.mit;
  };
}
