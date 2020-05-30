{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, six
, mock
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "0.3.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2062f2c7f95cc276a834c22f1a17179467176b624cc6f936e8bc3be5535ad1b";
  };

  propagatedBuildInputs = [ dateutil six ];
  checkInputs = [ mock nose pytest ];

  meta = with stdenv.lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
