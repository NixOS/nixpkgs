{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scikit-learn,
  numpy,
  scipy,
  jinja2,
  pytestCheckHook,
  networkx,
  matplotlib,
  igraph,
  plotly,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "kmapper";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-i909J0yI8v8BqGbCkcjBAdA02Io+qpILdDkojZj0wv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    scikit-learn
    numpy
    scipy
    jinja2
  ];

  pythonImportsCheck = [ "kmapper" ];

  nativeCheckInputs = [
    pytestCheckHook
    networkx
    matplotlib
    igraph
    plotly
    ipywidgets
  ];

  meta = with lib; {
    description = "Python implementation of Mapper algorithm for Topological Data Analysis";
    homepage = "https://kepler-mapper.scikit-tda.org/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
