{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, branca
, jinja2
, nbconvert
, numpy
, pandas
, pillow
, requests
, selenium
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.12.1.post1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    rev = "v${version}";
    sha256 = "sha256-4UseN/3ojZdDUopwZLpHZEBon1qDDvCWfdzxodi/BeA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    branca
    jinja2
    numpy
    requests
  ];

  checkInputs = [
    nbconvert
    pytestCheckHook
    pandas
    pillow
    selenium
  ];

  disabledTests = [
    # requires internet connection
    "test_geojson"
    "test_heat_map_with_weights"
    "test_json_request"
    "test_notebook"
  ];

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = "https://github.com/python-visualization/folium";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
