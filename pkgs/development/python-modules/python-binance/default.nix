{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, autobahn, certifi, chardet, cryptography, dateparser, pyopenssl, requests, service-identity, twisted }:

buildPythonPackage rec {
  version = "0.7.9";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "476459d91f6cfe0a37ccac38911643ea6cca632499ad8682e0957a075f73d239";
  };

  doCheck = false;  # Tries to test multiple interpreters with tox
  checkInputs = [ pytest requests-mock tox ];

  propagatedBuildInputs = [ autobahn certifi chardet cryptography dateparser pyopenssl requests service-identity twisted ];

  meta = {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = "https://github.com/sammchardy/python-binance";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
