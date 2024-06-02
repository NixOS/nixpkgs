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
  faker,
  pytestCheckHook,
  pytest-mock,
  eval-type-backport,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-IyVFpe7GaK4T8XDf2iDhtHYJ+8xhp5GSoJRcAnS7iTY=";
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

  passthru.optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs =
    [
      cloudpickle
      dirty-equals
      faker
      pytest-mock
      pytestCheckHook
    ]
    ++ lib.flatten (lib.attrValues passthru.optional-dependencies)
    ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

  preCheck = ''
    export HOME=$(mktemp -d)
    substituteInPlace pyproject.toml \
      --replace "'--benchmark-columns', 'min,mean,stddev,outliers,rounds,iterations'," "" \
      --replace "'--benchmark-group-by', 'group'," "" \
      --replace "'--benchmark-warmup', 'on'," "" \
      --replace "'--benchmark-disable'," ""
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
