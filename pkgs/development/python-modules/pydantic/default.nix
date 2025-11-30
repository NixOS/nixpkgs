{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  jsonschema,
  pytestCheckHook,
  pytest-codspeed,
  pytest-mock,
  pytest-run-parallel,
  eval-type-backport,
  rich,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.11.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-5EQwbAqRExApJvVUJ1C6fsEC1/rEI6/bQEQkStqgf/Q=";
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
    jsonschema
    pytest-codspeed
    pytest-mock
    pytest-run-parallel
    pytestCheckHook
    rich
  ]
  ++ lib.concatAttrValues optional-dependencies
  ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    "tests/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
