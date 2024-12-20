{
  lib,
  aenum,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  flatdict,
  jwcrypto,
  pycryptodome,
  pycryptodomex,
  pydash,
  pyfakefs,
  pyjwt,
  pytest-asyncio,
  pytest-mock,
  pytest-recording,
  pytestCheckHook,
  python-jose,
  pythonOlder,
  pyyaml,
  setuptools,
  xmltodict,
  yarl,
}:

buildPythonPackage rec {
  pname = "okta";
  version = "2.9.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RgB1trUSAxrCpGJxyLt6lzQXHcVPVnqIUacynalUUzY=";
  };

  pythonRelaxDeps = [ "aenum" ];

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiohttp
    flatdict
    jwcrypto
    pycryptodome
    pycryptodomex
    pydash
    pyjwt
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

  pytestFlagsArray = [ "tests/" ];

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
