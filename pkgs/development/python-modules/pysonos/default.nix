{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, xmltodict
, requests
, ifaddr

# Test dependencies
, pytest, pylint, flake8, graphviz
, mock, sphinx, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.37";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "43a046c1c6086500fb0f4be1094ca963f5b0f555a04b692832b2b88ab741824e";
  };

  propagatedBuildInputs = [ xmltodict requests ifaddr ];

  checkInputs = [
    pytest pylint flake8 graphviz
    mock sphinx sphinx_rtd_theme
  ];

  checkPhase = ''
    pytest --deselect=tests/test_discovery.py::TestDiscover::test_discover
  '';

  meta = {
    homepage = "https://github.com/amelchio/pysonos";
    description = "A SoCo fork with fixes for Home Assistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
