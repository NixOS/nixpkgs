{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  einops,
<<<<<<< HEAD
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
=======
  numpy,
  matplotlib,
  pandas,
  pytorch-msssim,
  scipy,
  torch,
  torch-geometric,
  torchvision,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # optional-dependencies
  ipywidgets,
  jupyter,

  # tests
  plotly,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "compressai";
<<<<<<< HEAD
  version = "1.2.8";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "InterDigitalInc";
    repo = "CompressAI";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Fgobh7Q1rKomcqAT4kJl2RsM1W13ErO8sFB2urCqrCk=";
=======
    hash = "sha256-xvzhhLn0iBzq3h1nro8/83QWEQe9K4zRa3RSZk+hy3Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  build-system = [
    pybind11
    setuptools
  ];

<<<<<<< HEAD
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
=======
  dependencies = [
    einops
    numpy
    matplotlib
    pandas
    pytorch-msssim
    scipy
    torch
    torch-geometric
    torchvision
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # We have to delete the source because otherwise it is used intead the installed package.
  preCheck = ''
    rm -rf compressai
=======
  preCheck = ''
    # We have to delete the source because otherwise it is used intead the installed package.
    rm -rf compressai

    export HOME=$(mktemp -d)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "test_compiling"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "test_find_close"
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
}
