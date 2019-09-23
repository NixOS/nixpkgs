{ stdenv
, buildPythonPackage
, fetchPypi
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "19.7.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15lhv18za0zv36laksr86rszjhp0slmqzcylm6ds9vpd7gyqprb8";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/flyingcircus/pycountry;
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
