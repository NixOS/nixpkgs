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

buildPythonPackage (finalAttrs: {
  pname = "kmapper";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    tag = "v${finalAttrs.version}";
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

  disabledTests = [
    # UnboundLocalError: cannot access local variable 'X_blend' where it is not associated with a value
    "test_tuple_projection"
    "test_tuple_projection_fit"
  ];

  meta = {
    description = "Python implementation of Mapper algorithm for Topological Data Analysis";
    homepage = "https://kepler-mapper.scikit-tda.org/";
    downloadPage = "https://github.com/scikit-tda/kepler-mapper";
    changelog = "https://github.com/scikit-tda/kepler-mapper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
