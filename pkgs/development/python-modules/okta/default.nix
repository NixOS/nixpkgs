{
  lib,
  aenum,
  aiohttp,
  blinker,
  buildPythonPackage,
  fetchPypi,
  flatdict,
  jwcrypto,
  pycryptodomex,
  pydantic,
  pydash,
  pyfakefs,
  pyjwt,
  pytest-asyncio,
  pytest-mock,
  pytest-recording,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  setuptools,
  xmltodict,
  yarl,
}:

buildPythonPackage rec {
  pname = "okta";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ZYDrup+HJxlrOmSBGsWD4Ku8HRlQR4E68olWQtcazg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiohttp
    blinker
    flatdict
    jwcrypto
    pycryptodomex
    pydantic
    pydash
    pyjwt
    python-dateutil
    pyyaml
    requests
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

  meta = {
    description = "Python SDK for the Okta Management API";
    homepage = "https://github.com/okta/okta-sdk-python";
    changelog = "https://github.com/okta/okta-sdk-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jbgosselin ];
  };
}
