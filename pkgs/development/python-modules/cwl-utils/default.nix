{
  lib,
  buildPythonPackage,
  cwl-upgrader,
  cwlformat,
  fetchFromGitHub,
  hatchling,
  jsonschema,
  packaging,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  rdflib,
  requests,
  ruamel-yaml,
  schema-salad,
}:

buildPythonPackage (finalAttrs: {
  pname = "cwl-utils";
  version = "0.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwl-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-78Kx+LCEcPE7qsV6MFtfSY6tVj5KZhifFOib7beCU2c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cwl-upgrader
    packaging
    rdflib
    requests
    ruamel-yaml
    schema-salad
  ];

  nativeCheckInputs = [
    cwlformat
    jsonschema
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cwl_utils" ];

  disabledTests = [
    # Don't run tests which require Node.js
    "test_context_multiple_regex"
    "test_value_from_two_concatenated_expressions"
    "test_graph_split"
    "test_caches_js_processes"
    "test_load_document_with_remote_uri"
    # Don't run tests which require network access
    "test_remote_packing"
    "test_remote_packing_github_soft_links"
    "test_cwl_inputs_to_jsonschema"
  ];

  meta = {
    description = "Utilities for CWL";
    homepage = "https://github.com/common-workflow-language/cwl-utils";
    changelog = "https://github.com/common-workflow-language/cwl-utils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
