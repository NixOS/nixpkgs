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
  version = "0.0.23";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kc2j2wl1bblqzay9gd3frd3imvylxjkqrp6jxixc4kmiivbg8h8";
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
