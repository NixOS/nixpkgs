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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bec945bffb0cee0503ef3c246fc5179523e874f86dd7769e987812f59ef973d";
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
    homepage = "https://kepler-mapper.scikit-tda.org/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
