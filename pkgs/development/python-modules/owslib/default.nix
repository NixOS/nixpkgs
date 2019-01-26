{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1px2nmbpbpp556kjq0ym0a7j24nbvs4w829727b2gr4a4ff86hxc";
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
