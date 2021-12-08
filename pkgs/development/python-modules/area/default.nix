{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "area";
  version = "1.1.1";

  src = fetchFromGitHub {
     owner = "scisco";
     repo = "area";
     rev = "v1.1.1";
     sha256 = "1r755xnskdvd51was0kx70ddbb96r08lycgaqzm55fiwi7f91ppz";
  };

  # tests not working on the package from pypi
  doCheck = false;

  meta = with lib; {
    description = "Calculate the area inside of any GeoJSON geometry. This is a port of Mapbox’s geojson-area for Python.";
    homepage = "https://github.com/scisco/area";
    license = licenses.bsd2;
  };
}
