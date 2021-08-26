{ lib, buildPythonPackage, fetchPypi, docutils, pybtex, six }:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "pybtex-docutils";

  doCheck = false;
  buildInputs = [ docutils pybtex six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "d53aa0c31dc94d61fd30ea3f06c749e6f510f9ff0e78cb2765a9300f173d8626";
  };

  meta = with lib; {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = licenses.mit;
  };
}
