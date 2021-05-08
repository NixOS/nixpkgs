{ lib
, buildPythonPackage
, fetchFromGitHub
, scikitlearn
, numpy
, scipy
, jinja2
, pytestCheckHook
, networkx
, matplotlib
, python-igraph
, plotly
, ipywidgets
}:

buildPythonPackage rec {
  pname = "kmapper";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "kepler-mapper";
    rev = "v${version}";
    sha256 = "0djm27si2bn18khrbb7rwhflc5ma6g9smhikhk5i1apwn5avm6l4";
  };

  propagatedBuildInputs = [
    scikitlearn
    numpy
    scipy
    jinja2
  ];

  checkInputs = [
    pytestCheckHook
    networkx
    matplotlib
    python-igraph
    plotly
    ipywidgets
  ];

  meta = with lib; {
    description = "Python implementation of Mapper algorithm for Topological Data Analysis";
    homepage = "https://kepler-mapper.scikit-tda.org/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
