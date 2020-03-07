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
  version = "0.0.24";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "294ffce5394a3e0da6a6f4e23f84031f06d9eb76eaa362507c0b1033ffbf69b4";
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
    homepage = https://github.com/amelchio/pysonos;
    description = "A SoCo fork with fixes for Home Assistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
