{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  libgeoip,
}:

buildPythonPackage rec {
  pname = "geoip";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "GeoIP";
    inherit version;
    hash = "sha256-qJDaaiFXQFBpIZjxSweqQmigE3Enjfwk9xzZvIfr8OY=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ libgeoip ];

  # Tests cannot be run because they require data that isn't included in the
  # release tarball.
  doCheck = false;

  meta = {
    description = "MaxMind GeoIP Legacy Database - Python API";
    homepage = "https://www.maxmind.com/";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.lgpl21Plus;
  };
}
