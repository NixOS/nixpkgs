{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  importlib-metadata,
  jsonschema,
  license-expression,
  lxml,
  packageurl-python,
  py-serializable,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requirements-parser,
  sortedcontainers,
  setuptools,
  toml,
  types-setuptools,
  types-toml,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "7.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python-lib";
    rev = "refs/tags/v${version}";
    hash = "sha256-KvP3msV2qIn26pSLv0XrxnwqRx7uWcllLTJg9vig5V0=";
  };

  pythonRelaxDeps = [ "py-serializable" ];

  build-system = [ poetry-core ];

  dependencies = [
    importlib-metadata
    license-expression
    packageurl-python
    requirements-parser
    setuptools
    sortedcontainers
    toml
    py-serializable
    types-setuptools
    types-toml
  ];

  passthru.optional-dependencies = {
    validation = [
      jsonschema
      lxml
    ];
    json-validation = [
      jsonschema
    ];
    xml-validation = [
      lxml
    ];
  };

  nativeCheckInputs = [
    ddt
    pytestCheckHook
    xmldiff
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "cyclonedx" ];

  preCheck = ''
    export PYTHONPATH=tests''${PYTHONPATH+:$PYTHONPATH}
  '';

  pytestFlagsArray = [ "tests/" ];

  disabledTests = [
    # These tests require network access
    "test_bom_v1_3_with_metadata_component"
    "test_bom_v1_4_with_metadata_component"
    # AssertionError: <ValidationError: "{'algorithm': 'ES256', ...
    "TestJson"
  ];

  disabledTestPaths = [
    # Test failures seem py-serializable related
    "tests/test_output_xml.py"
  ];

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    changelog = "https://github.com/CycloneDX/cyclonedx-python-lib/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
