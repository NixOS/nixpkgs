{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  flit-core_3,

  # dependencies
  orderly-set,

  # optional-dependencies
  click,
  orjson,
  pyyaml,

  # tests
  jsonpickle,
  numpy,
  pandas,
  polars,
  pydantic,
  pytestCheckHook,
  python-dateutil,
  pytz,
  tomli-w,
  uuid6,
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlustered";
    repo = "deepdiff";
    tag = version;
    hash = "sha256-+QHYYts6FGOrg01+SjUQTxW6kjbwIG3NVSKDYKWvels=";
  };

  build-system = [
    flit-core_3
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
    pandas
    polars
    pydantic
    pytestCheckHook
    python-dateutil
    pytz
    tomli-w
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
    # Requires too much RAM and fails only on Darwin from some reason.
    "test_restricted_unpickler_memory_exhaustion_cve"
  ];

  pythonImportsCheck = [ "deepdiff" ];

  meta = {
    description = "Deep Difference and Search of any Python object/data";
    mainProgram = "deep";
    homepage = "https://github.com/qlustered/deepdiff";
    changelog = "https://github.com/qlustered/deepdiff/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      doronbehar
    ];
  };
}
