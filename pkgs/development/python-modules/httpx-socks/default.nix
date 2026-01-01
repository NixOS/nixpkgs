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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  starlette,
  tiny-proxy,
  trio,
  trustme,
  yarl,
}:

buildPythonPackage rec {
  pname = "httpx-socks";
<<<<<<< HEAD
  version = "0.11.0";
  pyproject = true;

=======
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "httpx-socks";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/8nz/5LqEuSr8A8/BWzJM9vHuum6fOYIS2rozr4Omi4=";
=======
    hash = "sha256-1NDsIKJ8lWpjaTnlv5DrwTsEJU4gYwEUuqKpn+2QVhg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    changelog = "https://github.com/romis2012/httpx-socks/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    changelog = "https://github.com/romis2012/httpx-socks/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
