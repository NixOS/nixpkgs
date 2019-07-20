{ stdenv, buildPythonPackage, fetchPypi, srptools, aiohttp, zeroconf
, ed25519, cryptography, curve25519-donna, pytest, pytestrunner
, netifaces, asynctest, virtualenv, toml, filelock, tox }:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "135xvy1nn0x5knc7l05amfs837xkx2gcg3lpp69ya9kqs8j6brgp";
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
