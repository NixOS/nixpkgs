{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  annotated-types,
  pydantic-core,
  typing-extensions,
  typing-inspection,

  # tests
  cloudpickle,
  email-validator,
  dirty-equals,
  hypothesis,
  inline-snapshot,
  jsonschema,
  pytestCheckHook,
  pytest-mock,
  pytest-run-parallel,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-LxHj9qK0PQytn+9gnhHNvlyGEvkjJmOEoedctYbyWjk=";
  };

  postPatch = ''
    sed -i "/--benchmark/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    annotated-types
    pydantic-core
    typing-extensions
    typing-inspection
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    cloudpickle
    dirty-equals
    hypothesis
    (inline-snapshot.overridePythonAttrs { doCheck = false; })
    jsonschema
    pytest-mock
    pytest-run-parallel
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"
    "tests/pydantic_core/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
    "tests/pydantic_core/test_docstrings.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      wd15
    ];
  };
}
