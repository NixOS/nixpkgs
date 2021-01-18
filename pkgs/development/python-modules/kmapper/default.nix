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
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bb09d016ae0dc3308c2901f0775139a26e7f689afacea564a74e5627de35cd7";
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
