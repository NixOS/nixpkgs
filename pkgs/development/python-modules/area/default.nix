{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "area";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18k5hwmlxhajlq306zxndsglb11vv8vd4vpmwx8dpvfxd1kbksya";
  };

  # tests not working on the package from pypi
  doCheck = false;

  meta = with lib; {
    description = "Calculate the area inside of any GeoJSON geometry. This is a port of Mapbox’s geojson-area for Python.";
    homepage = "https://github.com/scisco/area";
    license = licenses.bsd2;
  };
}
