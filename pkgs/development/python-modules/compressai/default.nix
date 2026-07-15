{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  einops,
  matplotlib,
  numpy,
  pandas,
  pytorch-msssim,
  scipy,
  tomli,
  torch,
  torch-geometric,
  torchvision,
  tqdm,
  typing-extensions,

  # optional-dependencies
  ipywidgets,
  jupyter,

  # tests
  plotly,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "compressai";
  version = "1.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "InterDigitalInc";
    repo = "CompressAI";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Fgobh7Q1rKomcqAT4kJl2RsM1W13ErO8sFB2urCqrCk=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  pythonRelaxDeps = [
    "numpy"
  ];
  dependencies = [
    einops
    matplotlib
    numpy
    pandas
    pytorch-msssim
    scipy
    tomli
    torch
    torch-geometric
    torchvision
    tqdm
    typing-extensions
  ];

  optional-dependencies = {
    tutorials = [
      ipywidgets
      jupyter
    ];
  };

  pythonImportsCheck = [
    "compressai"
    "compressai._CXX"
  ];

  # We have to delete the source because otherwise it is used intead the installed package.
  preCheck = ''
    rm -rf compressai
  '';

  nativeCheckInputs = [
    plotly
    pytestCheckHook
  ];

  disabledTests = [
    # Those tests require internet access to download some weights
    "test_image_codec"
    "test_update"
    "test_eval_model_pretrained"
    "test_cheng2020_anchor"
    "test_pretrained"

    # Flaky (AssertionError: assert 0.08889999999999998 < 0.064445)
    "test_compiling"
    "test_find_close"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AttributeError: '...' object has no attribute '__annotations__'
    "test_gdn"
    "test_gdn1"
    "test_lower_bound_script"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Cause pytest to hang on Darwin after the tests are done
    "tests/test_eval_model.py"
    "tests/test_train.py"

    # fails in sandbox as it tries to launch a web browser (which fails due to missing `osascript`)
    "tests/test_plot.py::test_plot[plotly-ms-ssim-rgb]"
  ];

  meta = {
    description = "PyTorch library and evaluation platform for end-to-end compression research";
    homepage = "https://github.com/InterDigitalInc/CompressAI";
    license = lib.licenses.bsd3Clear;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
