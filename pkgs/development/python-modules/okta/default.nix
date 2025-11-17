{
  lib,
  aenum,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  flatdict,
  jwcrypto,
  pycryptodomex,
  pydash,
  pyfakefs,
  pyjwt,
  pytest-asyncio,
  pytest-mock,
  pytest-recording,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  xmltodict,
  yarl,
}:

buildPythonPackage rec {
  pname = "okta";
  version = "2.9.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jY6SZ1G3+NquF5TfLsGw6T9WO4smeBYT0gXLnRDoN+8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiohttp
    flatdict
    jwcrypto
    pycryptodomex
    pydash
    pyjwt
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

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    "test_client_raise_exception"
    # vcr.errors.CannotOverwriteExistingCassetteException: Can't overwrite existing cassette
    "test_get_org_contact_user"
    "test_update_org_contact_user"
    "test_get_role_subscription"
    "test_subscribe_unsubscribe"
    "test_client_invalid_url"
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
