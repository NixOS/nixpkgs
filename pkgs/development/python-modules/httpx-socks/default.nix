{ lib
, async-timeout
, buildPythonPackage
, curio
, fetchFromGitHub
, flask
, httpcore
, httpx
, hypercorn
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, python-socks
, pythonOlder
, sniffio
, starlette
, trio
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wigmkhn4ymfr12z9vhdaimjcma9llicwrr29q0cc8xmy23f3445";
  };

  propagatedBuildInputs = [
    async-timeout
    curio
    httpcore
    httpx
    python-socks
    sniffio
    trio
  ];

  checkInputs = [
    flask
    hypercorn
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    starlette
    yarl
  ];

  pythonImportsCheck = [
    "httpx_socks"
  ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
