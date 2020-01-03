{ lib, buildPythonPackage, fetchPypi, dateutil, requests, pytz, pyproj , pytest } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rdhymayyc6w1izlv1bf2wgx2dfxbp4k1vll5s1364isw60rjj8x";
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
