{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, autobahn, certifi, chardet, cryptography, dateparser, pyopenssl, requests, service-identity, twisted }:

buildPythonPackage rec {
  version = "0.7.1";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ce406da68bfbc209ae6852d1b8a2812708d04502f82a61b0c9ca41356cc6ab7";
  };

  doCheck = false;  # Tries to test multiple interpreters with tox
  checkInputs = [ pytest requests-mock tox ];

  propagatedBuildInputs = [ autobahn certifi chardet cryptography dateparser pyopenssl requests service-identity twisted ];

  meta = {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = https://github.com/sammchardy/python-binance;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
