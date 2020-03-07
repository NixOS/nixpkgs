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
  version = "0.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a4d9c8cd3c04a201e20c313caf8b6338f1cfa4cda43f46a94cc4a9fd13ea5e7";
  };

  propagatedBuildInputs = [ dateutil six ];
  checkInputs = [ mock nose pytest ];

  meta = with stdenv.lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
