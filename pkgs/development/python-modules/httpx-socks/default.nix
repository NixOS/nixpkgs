{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  httpcore,
  httpx,
  hypercorn,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
  python-socks,
  pythonOlder,
  setuptools,
  starlette,
  tiny-proxy,
  trio,
  trustme,
  yarl,
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "httpx-socks";
    tag = "v${version}";
    hash = "sha256-1NDsIKJ8lWpjaTnlv5DrwTsEJU4gYwEUuqKpn+2QVhg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    httpcore
    python-socks
  ]
  ++ python-socks.optional-dependencies.asyncio;

  optional-dependencies = {
    asyncio = [ async-timeout ];
    trio = [ trio ];
  };

  __darwinAllowLocalNetworking = true;

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

  pythonImportsCheck = [ "httpx_socks" ];

  disabledTests = [
    # Tests don't work in the sandbox
    "test_proxy"
    "test_secure_proxy"
  ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    changelog = "https://github.com/romis2012/httpx-socks/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
