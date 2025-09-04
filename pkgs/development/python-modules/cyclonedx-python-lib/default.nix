{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  jsonschema,
  referencing,
  license-expression,
  lxml,
  packageurl-python,
  py-serializable,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  sortedcontainers,
  typing-extensions,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "11.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python-lib";
    tag = "v${version}";
    hash = "sha256-TS/3O/ojabMUUW8RVd1ymo67rjNoRCtrIqZcUygpW+Y=";
  };

  pythonRelaxDeps = [ "py-serializable" ];

  build-system = [ poetry-core ];

  dependencies = [
    packageurl-python
    py-serializable
    sortedcontainers
    license-expression
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  optional-dependencies = {
    validation = [
      jsonschema
      referencing
      lxml
    ]
    ++ jsonschema.optional-dependencies.format-nongpl;
    json-validation = [
      jsonschema
      referencing
    ];
    xml-validation = [
      lxml
    ];
  };

  nativeCheckInputs = [
    ddt
    pytestCheckHook
    xmldiff
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "cyclonedx" ];

  preCheck = ''
    export PYTHONPATH=tests''${PYTHONPATH+:$PYTHONPATH}
  '';

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # These tests require network access
    "test_bom_v1_3_with_metadata_component"
    "test_bom_v1_4_with_metadata_component"
  ];

  meta = {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    changelog = "https://github.com/CycloneDX/cyclonedx-python-lib/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
