{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit
, async-timeout
, lxml
, httpx
, pytestCheckHook
, pytest-asyncio
, pytest-httpx
}:

buildPythonPackage rec {
  pname = "pyrmvtransport";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cgtobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m74m3dhxmbv10hsvs7cpshzs3pg66va5lyq94i5j1nxrl9i7spb";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    async-timeout
    httpx
    lxml
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
  ];

  pythonImportsCheck = [
    "RMVtransport"
  ];

  meta = with lib; {
    homepage = "https://github.com/cgtobi/PyRMVtransport";
    description = "Get transport information from opendata.rmv.de";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
