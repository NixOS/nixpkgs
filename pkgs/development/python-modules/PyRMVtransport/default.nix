{ lib, buildPythonPackage, fetchFromGitHub
, flit
, lxml, aiohttp
, pytest, pytestcov, pytest-asyncio, pytest-mock, pytest-aiohttp, aresponses
, pythonOlder
}:

buildPythonPackage rec {
  pname = "PyRMVtransport";
  version = "0.2.9";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cgtobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h3d0yxzrfi47zil5gr086v0780q768z8v5psvcikqw852f93vxb";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  checkInputs = [
    pytest
    pytestcov
    pytest-asyncio
    pytest-mock
    pytest-aiohttp
    aresponses
  ];
  checkPhase = ''
    pytest --cov=RMVtransport tests
  '';

  meta = with lib; {
    homepage = "https://github.com/cgtobi/PyRMVtransport";
    description = "Get transport information from opendata.rmv.de";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
