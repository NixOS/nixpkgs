{lib, buildPythonPackage, fetchPypi
, geoip, nose}:

buildPythonPackage rec {
  pname = "GeoIP";
  version = "1.3.2";

  nativeCheckInputs = [ nose ];
  propagatedBuildInputs = [
    geoip
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rphxf3vrn8wywjgr397f49s0s22m83lpwcq45lm0h2p45mdm458";
  };

  # Tests cannot be run because they require data that isn't included in the
  # release tarball.
  checkPhase = "true";

  meta = {
    description = "MaxMind GeoIP Legacy Database - Python API";
    homepage = "https://www.maxmind.com/";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.lgpl21Plus;
  };
}
