{ lib, buildPythonPackage, fetchPypi, python-dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4973c2ba65ec850a3fcc1fb94cefe5ed2fed83aaf2a5e2135c78810ad2a8f0e1";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ python-dateutil pyproj pytz requests pyyaml ];

  # 'tests' dir not included in pypy distribution archive.
  doCheck = false;

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    license = licenses.bsd3;
    homepage = "https://www.osgeo.org/projects/owslib/";
  };
}
