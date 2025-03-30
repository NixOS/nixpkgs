{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  orderly-set,

  # optional-dependencies
  click,
  orjson,
  pyyaml,

  # tests
  jsonpickle,
  numpy,
  pytestCheckHook,
  python-dateutil,
  toml,
  tomli-w,
  polars,
  pandas,
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "8.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    tag = version;
    hash = "sha256-RXr+6DLzhnuow9JNqqnNmuehE89eOY4oYn4tw4VSI+A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    orderly-set
  ];

  optional-dependencies = {
    cli = [
      click
      pyyaml
    ];
    optimize = [
      orjson
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
    changelog = "https://github.com/seperman/deepdiff/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      doronbehar
    ];
  };
}
