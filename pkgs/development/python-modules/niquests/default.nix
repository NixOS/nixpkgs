{
  buildPythonPackage,
  charset-normalizer,
  cryptography,
  fetchFromGitHub,
  hatchling,
  lib,
  orjson,
  pytest-asyncio,
  pytest-httpbin,
  pytestCheckHook,
  stdenv,
  urllib3-future,
  wassima,
}:

buildPythonPackage rec {
  pname = "niquests";
  version = "3.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "niquests";
    tag = "v${version}";
    hash = "sha256-QRVefE/85k6fT0zhAzX4wFB79ANf7LUshWsbi+fpSgk=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "wassima"
  ];

  dependencies = [
    charset-normalizer
    urllib3-future
    wassima
  ];

  optional-dependencies = {
    inherit (urllib3-future.optional-dependencies)
      brotli
      socks
      ws
      zstd
      ;
    full = [
      orjson
    ]
    ++ urllib3-future.optional-dependencies.brotli
    ++ urllib3-future.optional-dependencies.socks
    ++ urllib3-future.optional-dependencies.qh3
    ++ urllib3-future.optional-dependencies.ws
    ++ urllib3-future.optional-dependencies.zstd;
    http3 = urllib3-future.optional-dependencies.qh3;
    ocsp = urllib3-future.optional-dependencies.qh3;
    speedups = [
      orjson
    ]
    ++ urllib3-future.optional-dependencies.brotli
    ++ urllib3-future.optional-dependencies.zstd;
  };

  pythonImportsCheck = [ "niquests" ];

  nativeCheckInputs = [
    cryptography
    pytest-asyncio
    pytest-httpbin
    pytestCheckHook
  ]
  ++ optional-dependencies.socks;

  disabledTestPaths = [
    # tests connect to the internet
    "tests/test_requests.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # NameResolutionError: Failed to resolve 'localhost'
    "tests/test_lowlevel.py"
    "tests/test_testserver.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted
    "test_use_proxy_from_environment"
  ];

  meta = {
    changelog = "https://github.com/jawah/niquests/blob/${src.tag}/HISTORY.md";
    description = "Simple HTTP library that is a drop-in replacement for Requests";
    homepage = "https://github.com/jawah/niquests";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
