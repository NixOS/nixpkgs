{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, six
, mock
, nose
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e839b43bfbe8158b4d62bb97e6313d39f3586daf48e1314fb1083d2ef17700da";
  };

  propagatedBuildInputs = [ dateutil six ];
  buildInputs = [ mock nose ];

  meta = with stdenv.lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
