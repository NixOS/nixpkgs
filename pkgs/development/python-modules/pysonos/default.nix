{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, xmltodict
, requests
, ifaddr

# Test dependencies
, pytest_3, pylint, flake8, graphviz
, mock, sphinx, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.13";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0azkbd20qdzdilv5pi4qngw7pjjcsv269dim7xh3qv7s9bp0xik8";
  };

  propagatedBuildInputs = [ xmltodict requests ifaddr ];

  checkInputs = [
    pytest_3 pylint flake8 graphviz
    mock sphinx sphinx_rtd_theme
  ];

  meta = {
    homepage = https://github.com/amelchio/pysonos;
    description = "A SoCo fork with fixes for Home Assistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
