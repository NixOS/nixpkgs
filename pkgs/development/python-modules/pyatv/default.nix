{ stdenv, buildPythonPackage
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
  version = "0.7.5";
  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "06qj6r9kcal2nimg8rpjfid8rnlz43l7hn0v9v1mpayjmv2fl8sp";
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

  meta = with stdenv.lib; {
    description = "A python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
