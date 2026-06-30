{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "area";
  version = "1.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yuu5Zmjd7dtQ5/Vu0jbaO4RFn262fwMGplLBTiuHZaI=";
  };

  build-system = [ setuptools ];

  # tests not working on the package from pypi
  doCheck = false;

  pythonImportsCheck = [ "area" ];

  meta = {
    description = "Calculate the area inside of any GeoJSON geometry. This is a port of Mapbox’s geojson-area for Python";
    homepage = "https://github.com/scisco/area";
    license = lib.licenses.bsd2;
    hasNoMaintainersButDependents = true;
  };
})
