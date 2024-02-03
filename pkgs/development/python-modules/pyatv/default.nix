{ lib
, buildPythonPackage
, aiohttp
, bitarray
, chacha20poly1305-reuseable
, cryptography
, deepdiff
, fetchFromGitHub
, mediafile
, miniaudio
, netifaces
, protobuf
, pytest-aiohttp
, pytest-asyncio
, pytest-httpserver
, pytest-timeout
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, requests
, srptools
, stdenv
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.13.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rZnL18vO8eYn70GzeKSY528iTc0r/seGv0dYDYGHNzw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  pythonRelaxDeps = [
    "aiohttp"
    "async_timeout"
    "bitarray"
    "chacha20poly1305-reuseable"
    "cryptography"
    "ifaddr"
    "mediafile"
    "miniaudio"
    "protobuf"
    "requests"
    "srptools"
    "zeroconf"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    bitarray
    chacha20poly1305-reuseable
    cryptography
    mediafile
    miniaudio
    netifaces
    protobuf
    requests
    srptools
    zeroconf
  ];

  nativeCheckInputs = [
    deepdiff
    pytest-aiohttp
    pytest-asyncio
    pytest-httpserver
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  disabledTests = lib.optionals (stdenv.isDarwin) [
    # tests/protocols/raop/test_raop_functional.py::test_stream_retransmission[raop_properties2-2-True] - assert False
    "test_stream_retransmission"
  ];

  disabledTestPaths = [
    # Test doesn't work in the sandbox
    "tests/protocols/companion/test_companion_auth.py"
    "tests/protocols/mrp/test_mrp_auth.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "pyatv"
  ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    changelog = "https://github.com/postlund/pyatv/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
