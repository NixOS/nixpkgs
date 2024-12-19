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
  version = "0.19.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    tag = "v${version}";
    hash = "sha256-PBrrdFKEYj3yy+qV495It0HB9EVtJpjTY+oyls9Z/J0=";
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
    changelog = "https://github.com/python-visualization/folium/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = lib.teams.geospatial.members;
  };
}
