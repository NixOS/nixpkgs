{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  jsonschema,
  pytest-timeout,
  pytestCheckHook,
  pytest-mock,
  pytest-run-parallel,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.13.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-zxooO1fMqtD8Vy59odEcKBHaD6b7sSL4vScn0Z2+/Rs=";
  };

  patches = lib.optionals (lib.versionAtLeast python.version "3.14.1") [
    # Fix build with python 3.14.1
    (fetchpatch {
      url = "https://github.com/pydantic/pydantic/commit/53cb5f830207dd417d20e0e55aab2e6764f0d6fc.patch";
      hash = "sha256-Y1Ob1Ei0rrw0ua+0F5L2iE2r2RdpI9DI2xuiu9pLr5Y=";
    })
  ];

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
    "tests/pydantic_core/validators/test_allow_partial.py"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
