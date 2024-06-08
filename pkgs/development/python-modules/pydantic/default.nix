{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-neTdG/IcXopCmevzFY5/XDlhPHmOb6dhyAnzaobmeG8=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/pydantic/pydantic/pull/8678
      name = "fix-pytest8-compatibility.patch";
      url = "https://github.com/pydantic/pydantic/commit/825a6920e177a3b65836c13c7f37d82b810ce482.patch";
      hash = "sha256-Dap5DtDzHw0jS/QUo5CRI9sLDJ719GRyC4ZNDWEdzus=";
    })
  ];

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
