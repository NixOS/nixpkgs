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
  version = "0.0.14";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ebab661eb3ff9f814139924c18a87d0b1cab8a6af98d323e2b1ee313ed856c9";
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
