{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  click,
  orderly-set,
  orjson,

  # optional-dependencies
  clevercsv,

  # tests
  jsonpickle,
  numpy,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  toml,
  tomli-w,
  polars,
  pandas,
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "8.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    tag = version;
    hash = "sha256-b1L+8xOqxY2nI8UxZHxs3x28mVAzaRuPjYlPSqSapwk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    orderly-set
    orjson
  ];
  pythonRelaxDeps = [
    # Upstream develops this package as well, and from some reason pins this
    # dependency to a patch version below this one. No significant changes
    # happend in that relase, so we shouldn't worry, especially if tests pass.
    "orderly-set"
  ];

  optional-dependencies = {
    cli = [
      clevercsv
      click
      pyyaml
      toml
    ];
  };

  nativeCheckInputs = [
    jsonpickle
    numpy
    pytestCheckHook
    python-dateutil
    tomli-w
    polars
    pandas
  ] ++ optional-dependencies.cli;

  disabledTests = [
    # not compatible with pydantic 2.x
    "test_pydantic1"
    "test_pydantic2"
    # Require pytest-benchmark
    "test_cache_deeply_nested_a1"
    "test_lfu"
  ];

  pythonImportsCheck = [ "deepdiff" ];

  meta = {
    description = "Deep Difference and Search of any Python object/data";
    mainProgram = "deep";
    homepage = "https://github.com/seperman/deepdiff";
    changelog = "https://github.com/seperman/deepdiff/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      doronbehar
    ];
  };
}
