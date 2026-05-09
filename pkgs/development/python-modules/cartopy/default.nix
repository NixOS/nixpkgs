{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  gdal,
  geos,
  matplotlib,
  numpy,
  owslib,
  pillow,
  proj,
  pyproj,
  pyshp,
  scipy,
  setuptools-scm,
  shapely,
}:
buildPythonPackage rec {
  pname = "cartopy";
  version = "0.25.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VfGjkOXz8HWyIcfZH7ECWK2XjbeGx5MOugbrRdKHU/4=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
  ];

  buildInputs = [
    geos
    proj
  ];

  dependencies = [
    matplotlib
    numpy
    pyproj
    pyshp
    shapely
  ];

  optional-dependencies = {
    ows = [
      owslib
      pillow
    ];
    plotting = [
      gdal
      pillow
      scipy
    ];
  };

  doCheck = false; # Too fragile upon dependency update

  meta = {
    description = "Process geospatial data to create maps and perform analyses";
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    changelog = "https://github.com/SciTools/cartopy/releases/tag/v${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.turtley12 ];
    mainProgram = "feature_download";
  };
}
