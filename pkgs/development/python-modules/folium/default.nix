{
  lib,
  branca,
  buildPythonPackage,
  fetchFromGitHub,
  geodatasets,
  geopandas,
  jinja2,
  nbconvert,
  numpy,
  pandas,
  pillow,
  pytestCheckHook,
  pythonOlder,
  requests,
  selenium,
  setuptools,
  setuptools-scm,
  wheel,
  xyzservices,
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    rev = "refs/tags/v${version}";
    hash = "sha256-uKT6WqT3pI3rqfV/3CA+mXBk3F7h4RWW1h2FPIy0JH4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
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
    pytestCheckHook
    selenium
  ];

  disabledTests = [
    # Tests require internet connection
    "test__repr_png_is_bytes"
    "test_geojson"
    "test_heat_map_with_weights"
    "test_json_request"
    "test_notebook"
    "test_valid_png_size"
    "test_valid_png"
    # pooch tries to write somewhere it can, and geodatasets does not give us an env var to customize this.
    "test_timedynamic_geo_json"
  ];

  pythonImportsCheck = [ "folium" ];

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = "https://github.com/python-visualization/folium";
    changelog = "https://github.com/python-visualization/folium/blob/v${version}/CHANGES.txt";
    license = with lib.licenses; [ mit ];
    maintainers = lib.teams.geospatial.members;
  };
}
