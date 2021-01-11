{ lib, stdenv
, buildPythonPackage
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
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02ly89wwn0plcw8clkkzvxaw6zlpm8qyqpm9x2mfw4a0vppb4ngf";
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
