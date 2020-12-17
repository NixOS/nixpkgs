{ lib, buildPythonPackage, fetchFromGitHub
, flit
, lxml, httpx
, pytest, pytestcov, pytest-asyncio, pytest-mock, aresponses
, pythonOlder
}:

buildPythonPackage rec {
  pname = "PyRMVtransport";
  version = "0.2.10";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cgtobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "03qrylidb1d6zw6a22d1drdf73cvfxqcqaa8qi8x4pli1axcfh5w";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    httpx
    lxml
  ];

  # requires pytest-httpx
  doCheck = false;

  checkInputs = [
    pytest
    pytestcov
    pytest-asyncio
    pytest-mock
    # pytest-httpx is missing
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
