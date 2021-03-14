{ lib, buildPythonPackage
, aiohttp
, aiozeroconf
, asynctest
, cryptography
, deepdiff
, netifaces
, protobuf
, pytest
, pytest-aiohttp
, pytest-asyncio
, pytestrunner
, srptools
, zeroconf
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.7.6";
  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lahv6f97fizgh5b2w5yz9455l8ygn99rslhiygkgjywi2flx3p3";
  };

  nativeBuildInputs = [ pytestrunner];

  propagatedBuildInputs = [
    aiozeroconf
    srptools
    aiohttp
    protobuf
    cryptography
    netifaces
    zeroconf
  ];

  checkInputs = [
    deepdiff
    pytest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
