{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # native dependencies
  libxcrypt,

  # dependencies
  annotated-types,
  pydantic-core,
  typing-extensions,

  # tests
  cloudpickle,
  email-validator,
  dirty-equals,
  jsonschema,
  pytestCheckHook,
  pytest-mock,
  eval-type-backport,
  rich,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.10.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-/QxWgViqVmPnX/sO+qkvGl+WQX3OPXpS44CdP2HHOis=";
  };

  buildInputs = lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    annotated-types
    pydantic-core
    typing-extensions
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs =
    [
      cloudpickle
      dirty-equals
      jsonschema
      pytest-mock
      pytestCheckHook
      rich
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies)
    ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

  preCheck = ''
    export HOME=$(mktemp -d)
    substituteInPlace pyproject.toml \
      --replace-fail "'--benchmark-columns', 'min,mean,stddev,outliers,rounds,iterations'," "" \
      --replace-fail "'--benchmark-group-by', 'group'," "" \
      --replace-fail "'--benchmark-warmup', 'on'," "" \
      --replace-fail "'--benchmark-disable'," ""
  '';

  pytestFlagsArray = [
    # suppress warnings with pytest>=8
    "-Wignore::pydantic.warnings.PydanticDeprecatedSince20"
    "-Wignore::pydantic.json_schema.PydanticJsonSchemaWarning"
  ];

  disabledTests = [
    # disable failing test with pytest>=8
    "test_assert_raises_validation_error"
  ];

  disabledTestPaths = [
    "tests/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
