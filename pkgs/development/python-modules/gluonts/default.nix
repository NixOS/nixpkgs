{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  numpy,
  pandas,
  pydantic,
  tqdm,
  toolz,
  typing-extensions,

  # optional dependencies (torch)
  torch,
  lightning,
  scipy,

  # tests
  pytestCheckHook,
  distutils,
  matplotlib,
  pyarrow,
  statsmodels,
  writableTmpDirAsHomeHook,
  which,
}:

buildPythonPackage (finalAttrs: {
  pname = "gluonts";
  version = "0.17.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "gluonts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9X+cTwaoCsAgrjaZtWjDYDjYZO6MNPuBt0oGQUH8/nc=";
  };

  build-system = [
    hatchling
  ];

  patches = [
    # Fix pandas>=3 compatibility
    ./pandas3-compat.patch
  ];

  pythonRelaxDeps = [
    "pandas"
    "toolz"
  ];
  dependencies = [
    numpy
    pandas
    pydantic
    tqdm
    toolz
    typing-extensions
  ];

  optional-dependencies = {
    torch = [
      torch
      lightning
      scipy
    ];
  };

  pythonImportsCheck = [
    "gluonts"
    "gluonts.core"
    "gluonts.dataset"
    "gluonts.ev"
    "gluonts.evaluation"
    "gluonts.ext"
    "gluonts.model"
    "gluonts.shell"
    "gluonts.time_feature"
    "gluonts.torch"
    "gluonts.transform"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    distutils
    matplotlib
    pyarrow
    statsmodels
    writableTmpDirAsHomeHook
    which
  ]
  ++ finalAttrs.passthru.optional-dependencies.torch;

  disabledTestPaths = [
    # requires `cpflows`, not in Nixpkgs
    "test/torch/model"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Trace/BPT trap: 5
    "test/torch/test_torch_item_id_info.py"
  ];

  disabledTests = [
    # tries to access network
    "test_against_former_evaluator"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    "test_forecast"
  ];

  meta = {
    description = "Probabilistic time series modeling in Python";
    homepage = "https://ts.gluon.ai";
    changelog = "https://github.com/awslabs/gluonts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
