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
  version = "0.0.22";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a4fe630b97c81261246a448fe9dd2bdfaacd7df4453cf72f020599171416442";
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
