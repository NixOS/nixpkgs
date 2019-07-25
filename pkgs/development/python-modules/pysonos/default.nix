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
  version = "0.0.21";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x2nznjnm721qw9nys5ap3b6hq9s48bsd1yj5xih50pvn0rf0nz2";
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
