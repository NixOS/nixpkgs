{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "334988857b260c8cdf1f6698d07eab61839c51acb52ee10eed1275439200a40e";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ dateutil pyproj pytz requests pyyaml ];

  # 'tests' dir not included in pypy distribution archive.
  doCheck = false;

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    license = licenses.bsd3;
    homepage = "https://www.osgeo.org/projects/owslib/";
  };
}
