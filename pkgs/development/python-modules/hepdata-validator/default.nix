{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  jsonschema,
  packaging,
  pyyaml,
  requests,
  pytestCheckHook,
  pytest-cov,
  mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "hepdata-validator";
  version = "0.3.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HEPData";
    repo = "hepdata-validator";
    tag = finalAttrs.version;
    hash = "sha256-Cp5UF6ULnZhebwOuVKImwtz3ceL2iXFyDNH3RQPgpIA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    jsonschema
    packaging
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    mock
    pytest-cov
    pytestCheckHook
  ];

  # These tests require network access to download or resolve schemas.
  disabledTestPaths = [
    "testsuite/test_schema_downloader.py"
    "testsuite/test_schema_resolver.py"
  ];

  disabledTests = [
    # These require network access.
    "test_valid_schema_with_no_local_copy"
    "test_valid_submission_dir_remote_schema"
    "test_valid_submission_dir_remote_schema_no_autoloading"
    "test_valid_submission_dir_remote_schema_multiple_loads"
    "test_invalid_remote_schema"
  ];

  pythonImportsCheck = [ "hepdata_validator" ];

  meta = {
    description = "JSON schema and validation code for HEPData submissions";
    homepage = "https://github.com/HEPData/hepdata-validator";
    changelog = "https://github.com/HEPData/hepdata-validator/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
