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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3708d889f96f6bbe89c52000dd9378ca4c35638180ff894b64ebbdfcfe62aab2";
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
