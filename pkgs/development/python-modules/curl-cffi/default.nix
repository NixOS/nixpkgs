{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lexiforest";
    repo = "curl_cffi";
    tag = "v${version}";
    hash = "sha256-hpsAga5741oTBT87Rt7XTyxxu7SQ5Usw+2VVr54oA8k=";
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

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  pythonImportsCheck = [ "curl_cffi" ];

  nativeCheckInputs = [
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

  meta = with lib; {
    changelog = "https://github.com/lexiforest/curl_cffi/releases/tag/${src.tag}";
    description = "Python binding for curl-impersonate via cffi";
    homepage = "https://curl-cffi.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
