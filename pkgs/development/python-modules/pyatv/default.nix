{ lib
, buildPythonPackage
, aiohttp
, bitarray
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
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rpf8qspk433jpj7qy3mv20vf3hbm6msx3mii5kq0dmsh5pqy6h4";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    bitarray
    cryptography
    mediafile
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
