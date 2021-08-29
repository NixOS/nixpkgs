{ lib
, buildPythonPackage
, aiohttp
, aiozeroconf
, cryptography
, deepdiff
, fetchFromGitHub
, netifaces
, protobuf
, pytest-aiohttp
, pytest-asyncio
, pytest-runner
, pytest-timeout
, pytestCheckHook
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dPnh8XZN7ZVR2rYNnj7GSYXW5I2GNQwD/KRDTgs2AtI=";
  };

  nativeBuildInputs = [ pytest-runner];

  propagatedBuildInputs = [
    aiohttp
    aiozeroconf
    cryptography
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
