{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  geopandas,
  libpysal,
  matplotlib,
  networkx,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mapclassify";
  version = "2.10.0";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "mapclassify";
    tag = "v${version}";
    hash = "sha256-OQpDrxa0zRPDAdyS6KP5enb/JZwbYoXTV8kUijV3tNM=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    networkx
    numpy
    pandas
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    geopandas
    libpysal
    matplotlib
  ];

  # requires network access
  disabledTestPaths = [
    # this module does http requests *at import time*
    "mapclassify/tests/test_greedy.py"
    # depends on remote data
    "mapclassify/tests/test_rgba.py"
  ];

  disabledTests = [
    # depends on remote datasets
    "test_legendgram_map"
    "test_legendgram_most_recent_cmap"
  ];

  pythonImportsCheck = [ "mapclassify" ];

  meta = {
    description = "Classification Schemes for Choropleth Maps";
    homepage = "https://pysal.org/mapclassify/";
    changelog = "https://github.com/pysal/mapclassify/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
