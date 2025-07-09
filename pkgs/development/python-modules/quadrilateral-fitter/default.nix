{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,

  numpy,
  scipy,
  shapely,
}:

buildPythonPackage rec {
  pname = "quadrilateral-fitter";
  version = "1.12";
  pyproject = true;

  src = fetchPypi {
    pname = "quadrilateral_fitter";
    inherit version;
    hash = "sha256-NLFbBXxYz9fqYykiJ7FRPAsqZ0xj7XM5wkhHx4CsRlY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    shapely
  ];

  meta = {
    description = "Fits irregular quadrilaterals from polygons or point clouds";
    homepage = "https://github.com/Eric-Canas/quadrilateral-fitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nova ];
    platforms = lib.platforms.all;
  };
}
