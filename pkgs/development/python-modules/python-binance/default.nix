{ lib, buildPythonPackage, fetchPypi
, pytest, requests-mock, tox
, aiohttp
, dateparser
, requests
, six
, ujson
, websockets
}:

buildPythonPackage rec {
  version = "1.0.10";
  pname = "python-binance";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5U/xMJ0iPij3Y+6SKuKQHspSiktxJVrDQzHPoJCM4H8=";
  };

  propagatedBuildInputs = [ 
    aiohttp
    dateparser
    requests
    six
    ujson
    websockets
  ];

  checkInputs = [
    pytest
    requests-mock
  ];

  doCheck = false;  # Tries to test multiple interpreters with tox

  meta = {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = "https://github.com/sammchardy/python-binance";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
