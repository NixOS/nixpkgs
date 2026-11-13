{
  lib,
  buildPythonPackage,
  black,
  cachecontrol,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  mistune,
  mypy-extensions,
  mypy,
  pytest-xdist,
  pytestCheckHook,
  rdflib,
  requests,
  rich-argparse,
  ruamel-yaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "schema-salad";
  version = "8.10.20261106141337";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "schema_salad";
    tag = finalAttrs.version;
    hash = "sha256-dd1ZmD0BsJhRkNfdYr2B5ifkHwJH8Heq5umvjzqLFjg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    cachecontrol
    mistune
    mypy
    mypy-extensions
    rdflib
    requests
    rich-argparse
    ruamel-yaml
  ]
  ++ cachecontrol.optional-dependencies.filecache;

  optional-dependencies = {
    pycodegen = [ black ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    "test_load_by_yaml_metaschema"
    "test_detect_changes_in_html"
    # Setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
    # Test requires network
    "test_yaml_tab_error"
    "test_bad_schemas"
  ];

  pythonImportsCheck = [ "schema_salad" ];

  meta = {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    changelog = "https://github.com/common-workflow-language/schema_salad/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
