{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  addBinToPathHook,
  curl-impersonate-chrome,
  cffi,
  certifi,
  charset-normalizer,
  cryptography,
  fastapi,
  httpx,
  proxy-py,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
  python-multipart,
  trustme,
  uvicorn,
  websockets,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "curl-cffi";
  version = "0.14.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lexiforest";
    repo = "curl_cffi";
    tag = "v${version}";
    hash = "sha256-JXfqZTf26kl2P0OMAw/aTdjQaGtdyTpNnhRPlwMiZNw=";
  };

  patches = [ ./use-system-libs.patch ];
  buildInputs = [ curl-impersonate-chrome ];

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [
    cffi
    certifi
  ];

  pythonImportsCheck = [ "curl_cffi" ];

  nativeCheckInputs = [
    addBinToPathHook
    charset-normalizer
    cryptography
    fastapi
    httpx
    proxy-py
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    python-multipart
    trustme
    uvicorn
    websockets
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # import from $out
    rm -r curl_cffi
  '';

  enabledTestPaths = [
    "tests/unittest"
  ];

  disabledTestPaths = [
    # test accesses network
    "tests/unittest/test_smoke.py::test_async"
    # Runs out of memory while testing
    "tests/unittest/test_websockets.py"
  ];

  disabledTests = [
    # FIXME ImpersonateError: Impersonating chrome136 is not supported
    "test_impersonate_without_version"
    "test_with_impersonate"
    # InvalidURL: Invalid URL component 'path'
    "test_update_params"
    # tests access network
    "test_add_handle"
    "test_socket_action"
    "test_without_impersonate"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/lexiforest/curl_cffi/releases/tag/${src.tag}";
    description = "Python binding for curl-impersonate via cffi";
    homepage = "https://curl-cffi.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
}
