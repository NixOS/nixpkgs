{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "0.14.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "folium";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zxLFj5AeTVAxE0En7ZlbBdJEm3WrcPv23MgOhyfNi14=";
  };

  patches = [
    # Fix test failures with latest branca
    (fetchpatch {
      url = "https://github.com/python-visualization/folium/commit/b410ab21cc46ec6756c2f755e5e81dcdca029c53.patch";
      hash = "sha256-SVN4wKEep+VnAKnkJTf59rhnzHnbk6dV9XL5ntv4bog=";
    })
  ];

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

  nativeCheckInputs = [
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
