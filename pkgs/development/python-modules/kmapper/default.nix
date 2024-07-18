{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-i909J0yI8v8BqGbCkcjBAdA02Io+qpILdDkojZj0wv4=";
  };

  propagatedBuildInputs = [
    scikit-learn
    numpy
    scipy
    jinja2
  ];

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
    broken = true;
  };
}
