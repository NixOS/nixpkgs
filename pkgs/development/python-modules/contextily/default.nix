{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  geopy,
  joblib,
  matplotlib,
  mercantile,
  numpy,
  pillow,
  rasterio,
  requests,
  xyzservices,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "contextily";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZTT6pXAribRtDYG0xTh1Ty2LPdjMKYRUsRzO36Z+c6w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    geopy
    joblib
    matplotlib
    mercantile
    numpy
    pillow
    rasterio
    requests
    xyzservices
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestMarks = [
    "network"
  ];

  disabledTests = [
    # Tries to geocode through Nominatim.
    "test_place_with_custom_headers"
  ];

  pythonImportsCheck = [ "contextily" ];

  meta = {
    description = "Context geo-tiles in Python";
    homepage = "https://github.com/geopandas/contextily";
    changelog = "https://github.com/geopandas/contextily/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ siraben ];
    teams = [ lib.teams.geospatial ];
  };
}
