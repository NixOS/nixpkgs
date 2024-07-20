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
    sha256 = "1rphxf3vrn8wywjgr397f49s0s22m83lpwcq45lm0h2p45mdm458";
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
