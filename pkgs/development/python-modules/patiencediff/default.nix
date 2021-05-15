{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nm2242xgg59l06m54rzxp41aly3lxjh0a1s7h6dk7ryxjh002lv";
  };

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wildsebastian ];
  };
}
