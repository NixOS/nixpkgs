{ lib
, buildPythonPackage
, aiohttp
, audio-metadata
, bitarray
, cryptography
, deepdiff
, fetchFromGitHub
, miniaudio
, netifaces
, protobuf
, pytest-aiohttp
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ccmYNOYE+RkJiJbGkQgdYE8/X4xzyRT4dkMa/qSZEc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    audio-metadata
    bitarray
    cryptography
    miniaudio
    netifaces
    protobuf
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

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyatv" ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
