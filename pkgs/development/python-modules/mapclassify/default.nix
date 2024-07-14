{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  geopandas,
  libpysal,
  networkx,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mapclassify";
  version = "2.6.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "mapclassify";
    rev = "v${version}";
    hash = "sha256-lb2Ui6zdx6MQBtBrL/Xj9k7cm6De8aLEuBLZDhPPDnE=";
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
  ];

  # requires network access
  disabledTestPaths = [ "mapclassify/tests/test_greedy.py" ];

  pythonImportsCheck = [ "mapclassify" ];

  meta = {
    description = "Classification Schemes for Choropleth Maps";
    homepage = "https://pysal.org/mapclassify/";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
