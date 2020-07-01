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
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f9wj1ggllwpjd9nh6nsrck7m4gbz29q6vqbrhbkc2kz6waqkgwc";
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
