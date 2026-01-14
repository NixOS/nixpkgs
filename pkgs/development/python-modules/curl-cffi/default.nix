{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  addBinToPathHook,
  curl-impersonate,
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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lexiforest";
    repo = "curl_cffi";
    tag = "v${version}";
    hash = "sha256-5Q9oHAOjefihxj6xU1UGVTl6Ib31XqhrxLtOgI5VABs=";
  };

  patches = [ ./use-system-libs.patch ];

  buildInputs = [ curl-impersonate ];

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
    # Hangs the build (possibly forever) under websockets > 12
    # https://github.com/lexiforest/curl_cffi/issues/657
    "tests/unittest/test_websockets.py::test_websocket"
    # Runs out of memory while testing
    "tests/unittest/test_websockets.py::test_receive_large_messages_run_forever"
    # Fails on high core-count machines (including x86_64)
    "tests/unittest/test_websockets.py::on_message"
    "tests/unittest/test_websockets.py::test_on_data_callback"
    "tests/unittest/test_websockets.py::test_hello_twice_async"
  ];

  disabledTests = [
    # FIXME ImpersonateError: Impersonating chrome136 is not supported
    "test_impersonate_without_version"
    "test_with_impersonate"
    # Impersonating chrome142 is not supported
    "test_cli"
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
    maintainers = with lib.maintainers; [
      chuangzhu
      sarahec
    ];
  };
}
