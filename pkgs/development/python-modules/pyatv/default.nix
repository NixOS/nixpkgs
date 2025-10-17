{
  lib,
  buildPythonPackage,
  aiohttp,
  async-timeout,
  chacha20poly1305-reuseable,
  cryptography,
  deepdiff,
  fetchFromGitHub,
  ifaddr,
  miniaudio,
  protobuf,
  pydantic,
  pyfakefs,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest-httpserver,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools,
  srptools,
  stdenv,
  tabulate,
  tinytag,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "postlund";
    repo = "pyatv";
    tag = "v${version}";
    hash = "sha256-b5u9u5CD/1W422rCxHvoyBqT5CuBAh68/EUBzNDcXoE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  pythonRelaxDeps = [
    "aiohttp"
    "async_timeout"
    "bitarray"
    "chacha20poly1305-reuseable"
    "cryptography"
    "ifaddr"
    "miniaudio"
    "protobuf"
    "requests"
    "srptools"
    "zeroconf"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    chacha20poly1305-reuseable
    cryptography
    ifaddr
    miniaudio
    protobuf
    pydantic
    requests
    srptools
    tabulate
    tinytag
    zeroconf
  ];

  nativeCheckInputs = [
    deepdiff
    pyfakefs
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytest-asyncio_0
    pytest-httpserver
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/postlund/pyatv/issues/2365
      "test_simple_dispatch"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # tests/protocols/raop/test_raop_functional.py::test_stream_retransmission[raop_properties2-2-True] - assert False
      "test_stream_retransmission"
    ];

  disabledTestPaths = [
    # Test doesn't work in the sandbox
    "tests/protocols/companion/test_companion_auth.py"
    "tests/protocols/mrp/test_mrp_auth.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyatv" ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    changelog = "https://github.com/postlund/pyatv/blob/${src.tag}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
