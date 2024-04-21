{
  lib,
  black,
  buildPythonPackage,
  cachecontrol,
  fetchFromGitHub,
  importlib-resources,
  mistune,
  mypy,
  mypy-extensions,
  pytestCheckHook,
  pythonRelaxDepsHook,
  pythonOlder,
  rdflib,
  requests,
  ruamel-yaml,
  setuptools-scm,
  types-dataclasses,
  types-requests,
  types-setuptools,
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.5.20240410123758";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "schema_salad";
    rev = "refs/tags/${version}";
    hash = "sha256-AgXqeiA4sP7KBnUpb2uMWq45G0LhJ5uLtORrOG4UuB0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "black>=19.10b0,<23.12" "black>=19.10b0"
  '';

  build-system = [ setuptools-scm ];

  dependencies =
    [
      cachecontrol
      mistune
      mypy
      mypy-extensions
      rdflib
      requests
      ruamel-yaml
      types-dataclasses
      types-requests
      types-setuptools
    ]
    ++ cachecontrol.optional-dependencies.filecache
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.pycodegen;

  preCheck = ''
    rm tox.ini
  '';

  disabledTests = [
    "test_load_by_yaml_metaschema"
    # Setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
    # Test requires network
    "test_yaml_tab_error"
    "test_bad_schemas"
  ];

  pythonImportsCheck = [ "schema_salad" ];

  passthru.optional-dependencies = {
    pycodegen = [ black ];
  };

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    changelog = "https://github.com/common-workflow-language/schema_salad/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
