{ lib
, stdenv
, buildPythonPackage
, fetchPypi
# install requirements
, pycryptodome
, yarl
, flatdict
, python-jose
, aenum
, aiohttp
, pydash
, xmltodict
, pyyaml
# test requirements
, pytestCheckHook
, pytest-recording
, pytest-asyncio
, pytest-mock
, pyfakefs
}:

buildPythonPackage rec {
  pname = "okta";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
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
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    pytest-recording
    pyfakefs
  ];

  pytestFlagsArray = [ "tests/" ];

  disabledTests = [
    "test_client_raise_exception"
  ];

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
