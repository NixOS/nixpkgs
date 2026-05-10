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
  requirements-parser,
  sortedcontainers,
  setuptools,
  toml,
  types-setuptools,
  types-toml,
  xmldiff,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyclonedx-python-lib";
  version = "11.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-35JTr2he7sHOqG3Nd0UM9CZ4Q/HFv3UQsF6hxOKR/+k=";
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

  optional-dependencies = {
    validation = [
      jsonschema
      lxml
    ];
    json-validation = [ jsonschema ];
    xml-validation = [ lxml ];
  };

  nativeCheckInputs = [
    ddt
    pytestCheckHook
    xmldiff
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "cyclonedx" ];

  preCheck = ''
    export PYTHONPATH=tests''${PYTHONPATH+:$PYTHONPATH}
  '';

  enabledTestPaths = [ "tests/" ];

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

  meta = {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    changelog = "https://github.com/CycloneDX/cyclonedx-python-lib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
