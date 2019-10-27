{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "018p2ypmpbbcgl0hp92s0vig1wirh41lj0wy62aafn5050pmqr7m";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ dateutil pyproj pytz requests ];

  # 'tests' dir not included in pypy distribution archive.
  doCheck = false;

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    license = licenses.bsd3;
    homepage = https://www.osgeo.org/projects/owslib/;
  };
}
