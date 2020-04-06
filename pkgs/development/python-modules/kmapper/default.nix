{ lib
, buildPythonPackage
, fetchPypi
, scikitlearn
, numpy
, scipy
, jinja2
, pytest
, networkx
, matplotlib
, python-igraph
, plotly
, ipywidgets
}:

buildPythonPackage rec {
  pname = "kmapper";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0879294680c5d01a928847b818a3c4e07eded3f602f96e510858e68e74fa3783";
  };

  propagatedBuildInputs = [
    scikitlearn
    numpy
    scipy
    jinja2
  ];

  checkInputs = [
    pytest
    networkx
    matplotlib
    python-igraph
    plotly
    ipywidgets
  ];

  checkPhase = ''
    pytest test --ignore test/test_drawing.py
  '';

  meta = with lib; {
    description = "Python implementation of Mapper algorithm for Topological Data Analysis";
    homepage = https://kepler-mapper.scikit-tda.org/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
