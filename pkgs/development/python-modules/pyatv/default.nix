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
<<<<<<< HEAD
, pytest-httpserver
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-timeout
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, requests
, srptools
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
<<<<<<< HEAD
  version = "0.13.4";
=======
  version = "0.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-rZnL18vO8eYn70GzeKSY528iTc0r/seGv0dYDYGHNzw=";
=======
    rev = "v${version}";
    hash = "sha256-ng5KfW93p2/N2a6lnGbRJC6aWOQgTl0imBLdUIUlDic=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pytest-httpserver
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals (stdenv.isDarwin) [
    # tests/protocols/raop/test_raop_functional.py::test_stream_retransmission[raop_properties2-2-True] - assert False
    "test_stream_retransmission"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
