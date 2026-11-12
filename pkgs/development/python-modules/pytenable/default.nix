{
  lib,
  arrow,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  gql,
  graphql-core,
  marshmallow,
  pydantic-extra-types,
  pydantic,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytest-datafiles,
  pytest-vcr,
  pytestCheckHook,
  python-box,
  python-dateutil,
  requests-pkcs12,
  requests-toolbelt,
  requests,
  responses,
  restfly,
  semver,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytenable";
  version = "26.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenable";
    repo = "pyTenable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tomPmKljJiZ1Zop4HOXS1zCYBApGlNI6U4rdk6L/Plg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    arrow
    cryptography
    defusedxml
    gql
    graphql-core
    marshmallow
    pydantic
    pydantic-extra-types
    python-box
    python-dateutil
    requests
    requests-toolbelt
    restfly
    semver
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
    requests-pkcs12
    responses
  ];

  disabledTestPaths = [
    # Disable tests that requires network access
    "tests/io/"
  ];

  disabledTests = [
    # Test requires network access
    "test_assets_list_vcr"
    "test_events_list_vcr"
    "test_session_ssl_error"
  ];

  pythonImportsCheck = [ "tenable" ];

  meta = {
    description = "Python library for the Tenable.io and TenableSC API";
    homepage = "https://github.com/tenable/pyTenable";
    changelog = "https://github.com/tenable/pyTenable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
