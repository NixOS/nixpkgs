{
  lib,
  buildPythonPackage,
  branca,
  fetchFromGitHub,
  geodatasets,
  geopandas,
  jinja2,
  nbconvert,
  numpy,
  pandas,
  pillow,
  pixelmatch,
  pytestCheckHook,
  pythonOlder,
  requests,
  selenium,
  setuptools,
  setuptools-scm,
  xyzservices,
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    tag = "v${version}";
    hash = "sha256-yLF4TdrMVEtWvGXZGbwa3OxCkdXMsN4m45rPrGDHlCU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    branca
    jinja2
    numpy
    requests
    xyzservices
  ];

  nativeCheckInputs = [
    geodatasets
    geopandas
    nbconvert
    pandas
    pillow
    pixelmatch
    pytestCheckHook
    selenium
  ];

  disabledTests = [
    # Tests require internet connection
    "test_json_request"
    # no selenium driver
    "test__repr_png_is_bytes"
    "test_valid_png_size"
    "test_valid_png"
    # pooch tries to write somewhere it can, and geodatasets does not give us an env var to customize this.
    "test_timedynamic_geo_json"
  ];

  disabledTestPaths = [
    # Selenium cannot find chrome driver, even with chromedriver package
    "tests/snapshots/test_snapshots.py"
    "tests/selenium"
  ];

  pythonImportsCheck = [ "folium" ];

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = "https://github.com/python-visualization/folium";
    changelog = "https://github.com/python-visualization/folium/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.geospatial ];
  };
}
