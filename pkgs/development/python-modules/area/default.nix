{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "area";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18k5hwmlxhajlq306zxndsglb11vv8vd4vpmwx8dpvfxd1kbksya";
  };

  build-system = [ setuptools ];

  # tests not working on the package from pypi
  doCheck = false;

  meta = {
    description = "Calculate the area inside of any GeoJSON geometry. This is a port of Mapbox’s geojson-area for Python";
    homepage = "https://github.com/scisco/area";
    license = lib.licenses.bsd2;
  };
}
