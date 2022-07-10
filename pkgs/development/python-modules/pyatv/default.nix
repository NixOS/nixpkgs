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
, pythonOlder
, requests
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-70bimFWsby2x8wBRH5CZgg9Xjw8n+xfhW07rOG9Pk0s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    # Remove all version pinning

    substituteInPlace base_versions.txt \
      --replace "protobuf==3.19.1,<4" "protobuf>=3.19.0,<4"
  '';

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

  disabledTestPaths = [
    # Test doesn't work in the sandbox
    "tests/protocols/companion/test_companion_auth.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "pyatv"
  ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
