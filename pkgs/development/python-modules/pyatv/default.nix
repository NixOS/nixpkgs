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
, pytest-timeout
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, requests
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ng5KfW93p2/N2a6lnGbRJC6aWOQgTl0imBLdUIUlDic=";
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

  checkInputs = [
    deepdiff
    pytest-aiohttp
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
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
