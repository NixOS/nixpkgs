{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cs6y59qhbal8fgbyjk2lpjykh8kfjhq16clfssylsddb4hgnsmp";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = {
    description = "High-speed universal character encoding detector";
    homepage = "https://github.com/PyYoshi/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
