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
, setuptools
, sniffio
, starlette
, tiny-proxy
, trio
, trustme
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.7.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rLcYC8IO2eCWAL4QIiUg/kyigybq6VNTUjNDXx4KPHc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
    httpcore
    python-socks
  ];

  passthru.optional-dependencies = {
    asyncio = [
      async-timeout
    ];
    trio = [
      trio
    ];
  };

  nativeCheckInputs = [
    flask
    hypercorn
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    starlette
    tiny-proxy
    trustme
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
    changelog = "https://github.com/romis2012/httpx-socks/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
