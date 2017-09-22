{ stdenv, buildPythonPackage, fetchPypi
, nose }:

buildPythonPackage rec {
  pname = "pygeoip";
  version = "0.3.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f22c4e00ddf1213e0fae36dc60b46ee7c25a6339941ec1a975539014c1f9a96d";
  };

  # requires geoip samples
  doCheck = false;

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Pure Python GeoIP API";
    homepage = https://github.com/appliedsec/pygeoip;
    license = licenses.lgpl3Plus;
  };
}
