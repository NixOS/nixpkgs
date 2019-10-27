{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, autobahn, certifi, chardet, cryptography, dateparser, pyopenssl, requests, service-identity, twisted }:

buildPythonPackage rec {
  version = "0.7.4";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d0b81a9d395fd071581d275af09a31f0c5ae3ecb25a3f47faaaf1eff779de3f";
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
