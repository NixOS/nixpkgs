{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a03a9978673f377df45107024e2aae006f85afe7ef7bf4640ef663167a4386f";
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
