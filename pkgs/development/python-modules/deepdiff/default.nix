{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  flit-core,

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
  pydantic,
  tomli-w,
  polars,
  pandas,
  uuid6,
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "8.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    tag = version;
    hash = "sha256-1DB1OgIS/TSMd+Pqd2vvW+qwM/b5+Dy3qStlg+asidE=";
  };

  build-system = [
    flit-core
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
    pydantic
    tomli-w
    polars
    pandas
    uuid6
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # Require pytest-benchmark
    "test_cache_deeply_nested_a1"
    "test_lfu"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Times out on darwin in Hydra
    "test_repeated_timer"
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
