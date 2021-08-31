{ lib, buildPythonPackage, fetchPypi, python-dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20d79bce0be10277caa36f3134826bd0065325df0301a55b2c8b1c338d8d8f0a";
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
