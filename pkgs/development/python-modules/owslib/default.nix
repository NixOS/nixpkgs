{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19dm6dxj9hsiq0bnb4d6ms3sh2hcss9d9fhpjgkwxzrw9mlzvrxj";
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
