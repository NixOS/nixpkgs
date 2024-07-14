{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "area";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yuu5Zmjd7dtQ5/Vu0jbaO4RFn262fwMGplLBTiuHZaI=";
  };

  # tests not working on the package from pypi
  doCheck = false;

  meta = with lib; {
    description = "Calculate the area inside of any GeoJSON geometry. This is a port of Mapbox’s geojson-area for Python";
    homepage = "https://github.com/scisco/area";
    license = licenses.bsd2;
  };
}
