{ stdenv, buildPythonPackage, fetchPypi, srptools, aiohttp, zeroconf
, ed25519, cryptography, curve25519-donna, pytest, pytestrunner
, netifaces, asynctest, virtualenv, toml, filelock, tox }:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fc1a903a9d666e4109127410d35a83458559a86bc0de3fe1ffb3f15d2d653b3";
  };

  propagatedBuildInputs = [ srptools aiohttp zeroconf ed25519 cryptography curve25519-donna tox ];

  checkInputs = [ pytest pytestrunner netifaces asynctest virtualenv toml filelock ];

  meta = with stdenv.lib; {
    description = "A python client library for the Apple TV";
    homepage = https://github.com/postlund/pyatv;
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
