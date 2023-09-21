{ lib
, stdenv
, aenum
, aiohttp
, buildPythonPackage
, fetchPypi
, flatdict
, pycryptodome
, pycryptodomex
, pydash
, pyfakefs
, pytest-asyncio
, pytest-mock
, pytest-recording
, pytestCheckHook
, python-jose
, pythonOlder
, pyyaml
, xmltodict
, yarl
}:

buildPythonPackage rec {
  pname = "okta";
  version = "2.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kbzqriybzN/86vov3Q+kH2lj9plK1GzWPlc/Nc/nWF0=";
  };

  propagatedBuildInputs = [
    aenum
    aiohttp
    flatdict
    pycryptodome
    pycryptodomex
    pydash
    python-jose
    pyyaml
    xmltodict
    yarl
  ];

  checkInputs = [
    pyfakefs
    pytest-asyncio
    pytest-mock
    pytest-recording
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    "test_client_raise_exception"
    # vcr.errors.CannotOverwriteExistingCassetteException: Can't overwrite existing cassette
    "test_get_org_contact_user"
    "test_update_org_contact_user"
    "test_get_role_subscription"
    "test_subscribe_unsubscribe"
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
    changelog = "https://github.com/okta/okta-sdk-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
