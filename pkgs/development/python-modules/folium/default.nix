{ lib
, branca
, buildPythonPackage
, fetchFromGitHub
, geopandas
, jinja2
, nbconvert
, numpy
, pandas
, pillow
, pytestCheckHook
, pythonOlder
, requests
, selenium
, setuptools-scm
, xyzservices
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    rev = "refs/tags/v${version}";
    hash = "sha256-zxLFj5AeTVAxE0En7ZlbBdJEm3WrcPv23MgOhyfNi14=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    branca
    jinja2
    numpy
    requests
  ];

  nativeCheckInputs = [
    geopandas
    nbconvert
    pandas
    pillow
    pytestCheckHook
    selenium
    xyzservices
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
  ];

  pythonImportsCheck = [
    "folium"
  ];

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = "https://github.com/python-visualization/folium";
    changelog = "https://github.com/python-visualization/folium/blob/v${version}/CHANGES.txt";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
