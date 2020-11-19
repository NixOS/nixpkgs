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
  version = "0.7.4";
  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "17gsamn4aibsx4w50r9dwr5kr9anc7dd0f0dvmdl717rkgh13zyi";
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
