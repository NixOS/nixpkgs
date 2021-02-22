{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, xmltodict
, requests
, ifaddr

# Test dependencies
, pytest, pylint, flake8, graphviz
, mock, sphinx, sphinx_rtd_theme
, requests-mock
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.40";

  disabled = !isPy3k;

  # pypi package is missing test fixtures
  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a0c7jwv39nbvpdcx32sd8kjmj4nyrd7k0yxhpmxdnx4zr4vvzqg";
  };

  propagatedBuildInputs = [ xmltodict requests ifaddr ];

  checkInputs = [
    pytest pylint flake8 graphviz
    mock sphinx sphinx_rtd_theme
    requests-mock
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
