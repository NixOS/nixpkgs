{ lib
, buildPythonPackage
, fetchFromGitHub
, scikit-learn
, numpy
, scipy
, jinja2
, pytestCheckHook
, networkx
, matplotlib
, igraph
, plotly
, ipywidgets
}:

buildPythonPackage rec {
  pname = "kmapper";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    rev = "v${version}";
    sha256 = "1jqqrn7ig9kylcc8xbslxmchzghr9jgffaab3g3y3nyghk8azlgj";
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
