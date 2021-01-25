{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPy27
, dateutil
, six
, mock
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cf08e441f913ff5e59b19cc065a8faa9dd1ddc442eaf0375294f344581a0643";
  };

  propagatedBuildInputs = [ dateutil six ];
  checkInputs = [ mock nose pytest ];
  # contains python3 specific code
  doCheck = !isPy27;

  meta = with lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
