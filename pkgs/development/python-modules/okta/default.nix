{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pycryptodome
, yarl
, flatdict
, python-jose
, aenum
, aiohttp
, pydash
, xmltodict
, pyyaml
, pytest
, pytest-recording
, pytest-asyncio
, pytest-mock
, tox
}:

buildPythonPackage rec {
  pname = "okta";
  version = "2.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-yIVJoKX9b9Y7Ydl28twHxgPbUa58LJ12Oz3tvpU7CAc=";
  };

  propagatedBuildInputs = [
    pycryptodome
    yarl
    flatdict
    python-jose
    aenum
    aiohttp
    pydash
    xmltodict
    pyyaml
  ];

  checkInputs = [
    tox
    pytest
    pytest-asyncio
    pytest-mock
    pytest-recording
  ];

  checkPhase = ''
    tox
  '';

  pythonImportsCheck = [
    "okta"
    "okta.cache"
    "okta.client"
    "okta.exceptions"
    "okta.http_client"
    "okta.models"
    "okta.request_executor"
  ];

  meta = with lib; {
    description = "Python SDK for the Okta Management API";
    homepage = "https://github.com/okta/okta-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ dennajort ];
  };
}
