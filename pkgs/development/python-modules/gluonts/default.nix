{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  numpy,
  pandas,
  pydantic,
  tqdm,
  toolz,

  # optional dependencies (torch)
  torch,
  lightning,
  scipy,

  # test
  pytestCheckHook,
  distutils,
  matplotlib,
  pyarrow,
  statsmodels,
  which,
}:

buildPythonPackage rec {
  pname = "gluonts";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "gluonts";
    tag = "v${version}";
    hash = "sha256-h0+RYgGMz0gPchiKGIu0/NGcWBky5AWNTJKzoupn/iQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pandas
    pydantic
    tqdm
    toolz
  ];

  optional-dependencies = {
    torch = [
      torch
      lightning
      scipy
    ];
  };

  pythonRelaxDeps = [
    "numpy"
    "toolz"
  ];

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
    which
  ]
  ++ optional-dependencies.torch;

  preCheck = ''export HOME=$(mktemp -d)'';

  disabledTestPaths = [
    # requires `cpflows`, not in Nixpkgs
    "test/torch/model"
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
    changelog = "https://github.com/awslabs/gluonts/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
