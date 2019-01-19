{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2e7fd694d3cffcee79317bad492d60c0aa887aea6916517c051c3247b33b5a5";
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
