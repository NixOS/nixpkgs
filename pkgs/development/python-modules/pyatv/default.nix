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
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83d86fac517d33a1e3063a547ee2a520fde74c74a1b95cb5a6f20afccfd59843";
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
    broken = true;
    description = "A python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
