{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "456d9fc47fe43f9aea863059ea2c6df5b997285590e4b7f9ee8fbb6c3419b5a7";
  };

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wildsebastian ];
  };
}
