{ lib
, stdenv
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "okta";
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/okta/okta-sdk-python/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
