{
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
  writableTmpDirAsHomeHook,
}:
let
  # This is only used for testing and requires 12.0 specifically
  # due to incompatible API changes in later versions.
  websockets = buildPythonPackage rec {
    pname = "websockets";
    version = "12.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "aaugustin";
      repo = "websockets";
      tag = version;
      hash = "sha256-sOL3VI9Ib/PncZs5KN4dAIHOrBc7LfXqT15LO4M6qKg=";
    };

    build-system = [ setuptools ];

    doCheck = false;

    pythonImportsCheck = [ "websockets" ];
  };
in
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
