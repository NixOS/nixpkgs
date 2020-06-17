{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, autobahn, certifi, chardet, cryptography, dateparser, pyopenssl, requests, service-identity, twisted }:

buildPythonPackage rec {
  version = "0.7.5";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6a96c0e55fc78d45279944515d385b3971300f35c2380ddb82689d676712053";
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
