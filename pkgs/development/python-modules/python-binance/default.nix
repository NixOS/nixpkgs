{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, autobahn, certifi, chardet, cryptography, dateparser, pyopenssl, requests, service-identity, twisted }:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h8kd88j53w6yfc60fr8a45zi30p09l98vm8yzqym4lcgx76nvps";
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
