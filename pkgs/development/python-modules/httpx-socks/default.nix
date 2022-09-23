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
  version = "0.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+eWGmCHkXQA+JaEgofqUeFyGyMxSctal+jsqsShFM58=";
  };

  propagatedBuildInputs = [
    httpx
    httpcore
    python-socks
  ];

  passthru.optional-dependencies = {
    asyncio = [ async-timeout ];
    trio = [ trio ];
  };

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

  disabledTests = [
    # Tests don't work in the sandbox
    "test_proxy"
    "test_secure_proxy"
  ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
