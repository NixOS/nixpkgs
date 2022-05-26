{ lib, buildPythonPackage, fetchPypi, docutils, pybtex, six }:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "pybtex-docutils";

  doCheck = false;
  buildInputs = [ docutils pybtex six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q6o1O21Jj9WsMPAHOpjjMtBh00/mGdPVDRdh+P1KoBY=";
  };

  meta = with lib; {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = licenses.mit;
  };
}
