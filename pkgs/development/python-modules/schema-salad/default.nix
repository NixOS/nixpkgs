{ lib
, black
, buildPythonPackage
, cachecontrol
, fetchFromGitHub
, importlib-resources
, mistune
, mypy-extensions
, pytestCheckHook
, pythonOlder
, rdflib
, requests
, ruamel-yaml
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.5.20240311110950";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "schema_salad";
    rev = "refs/tags/${version}";
    hash = "sha256-bjeVgV9ovIVvGvSay24vKkzSXBbzgV05BkO5DojTX3o=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cachecontrol
    mistune
    mypy-extensions
    rdflib
    requests
    ruamel-yaml
  ] ++ cachecontrol.optional-dependencies.filecache
  ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pycodegen;

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

  pythonImportsCheck = [
    "schema_salad"
  ];

  passthru.optional-dependencies = {
    pycodegen = [
      black
    ];
  };

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    changelog = "https://github.com/common-workflow-language/schema_salad/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
