{
  lib,
  black,
  buildPythonPackage,
  cachecontrol,
  fetchFromGitHub,
  mistune,
  mypy,
  mypy-extensions,
  pytestCheckHook,
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
  version = "8.9.20250723145140";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "schema_salad";
    tag = version;
    hash = "sha256-FEdv0VORkvXhqXPrmyCZ1Ib5Lz4fKwRkEqEcEXpfGq8=";
  };

  pythonRelaxDeps = [ "mistune" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'pytest_runner + ["setuptools_scm>=8.0.4,<9"]' '["setuptools_scm"]'
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm[toml]>=8.0.4,<9"' '"setuptools_scm[toml]"' \
      --replace-fail "mypy[mypyc]==1.17.0" "mypy"
    sed -i "/black>=/d" pyproject.toml
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
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
  ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.pycodegen;

  preCheck = ''
    rm tox.ini
  '';

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

  optional-dependencies = {
    pycodegen = [ black ];
  };

  meta = {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    changelog = "https://github.com/common-workflow-language/schema_salad/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
