{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  numpy,
  scikit-learn,
  scipy,

  # tests
  anywidget,
  igraph,
  ipywidgets,
  matplotlib,
  networkx,
  plotly,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kmapper";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    tag = "v${version}";
    hash = "sha256-i909J0yI8v8BqGbCkcjBAdA02Io+qpILdDkojZj0wv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    numpy
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "kmapper" ];

  nativeCheckInputs = [
    anywidget
    igraph
    ipywidgets
    matplotlib
    networkx
    plotly
    pytestCheckHook
  ];

  meta = {
    description = "Python implementation of Mapper algorithm for Topological Data Analysis";
    homepage = "https://kepler-mapper.scikit-tda.org/";
    changelog = "https://github.com/scikit-tda/kepler-mapper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
