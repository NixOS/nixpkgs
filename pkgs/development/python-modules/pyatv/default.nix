{ stdenv, buildPythonPackage, fetchPypi
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
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17d4fb4fbdfe1c762e421ce2caa6beddab8ef9a6e0e5c7ab7eb54c8d8654c61c";
  };

  nativeBuildInputs = [ pytestrunner];

  propagatedBuildInputs = [
    aiozeroconf
    srptools
    aiohttp
    protobuf
    cryptography
    netifaces
  ];

  checkInputs = [
    deepdiff
    pytest
    pytest-aiohttp
    pytest-asyncio
  ];

  # just run vanilla pytest to avoid inclusion of coverage reports and xdist
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
