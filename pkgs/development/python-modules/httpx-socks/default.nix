{ lib
, async-timeout
, buildPythonPackage
, curio
, fetchFromGitHub
, flask
, httpcore
, httpx
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, python-socks
, pythonOlder
, sniffio
, trio
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cwazage26FkFOf0NObwhdfb35scT3SaX3UJFaoH733g=";
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
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    yarl
  ];

  pythonImportsCheck = [ "httpx_socks" ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
