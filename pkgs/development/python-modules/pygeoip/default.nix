{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  pname = "pygeoip";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8ixOAN3xIT4PrjbcYLRu58JaYzmUHsGpdVOQFMH5qW0=";
  };

  # requires geoip samples
  doCheck = false;

  buildInputs = [ nose ];

  meta = with lib; {
    description = "Pure Python GeoIP API";
    homepage = "https://github.com/appliedsec/pygeoip";
    license = licenses.lgpl3Plus;
  };
}
