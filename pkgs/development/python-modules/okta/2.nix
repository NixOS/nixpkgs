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
  pyyaml,
  setuptools,
  xmltodict,
  yarl,
}:

# gimme-aws-creds 2.8.2 requires okta < 3, but upstream nixpkgs `okta` has
# already moved to the pydantic-based 3.x rewrite. This pins the last okta 2.x
# release so gimme-aws-creds keeps building. Remove once gimme-aws-creds
# releases a version compatible with okta 3.
buildPythonPackage rec {
  pname = "okta";
  version = "2.9.13";
  pyproject = true;

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

  nativeCheckInputs = [
    pyfakefs
    pytest-asyncio
    pytest-mock
    pytest-recording
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # network access / live-recording related, not replayable from bundled cassettes
    "test_client_raise_exception"
    "test_client_invalid_url"
  ];

  pythonImportsCheck = [
    "okta"
    "okta.cache"
    "okta.client"
    "okta.config"
    "okta.errors"
    "okta.exceptions"
    "okta.http_client"
    "okta.models"
  ];

  # okta must stay at 2.x for gimme-aws-creds, see
  # https://github.com/NixOS/nixpkgs/pull/494062
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Python SDK for the Okta Management API";
    homepage = "https://github.com/okta/okta-sdk-python";
    changelog = "https://github.com/okta/okta-sdk-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jbgosselin ];
  };
}
