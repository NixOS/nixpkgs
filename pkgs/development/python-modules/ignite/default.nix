{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pytest-xdist,
  torchvision,
  matplotlib,
  mock,
  packaging,
  torch,
}:

buildPythonPackage rec {
  pname = "ignite";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "ignite";
    tag = "v${version}";
    hash = "sha256-aWm+rj/9A7oNBW5jkMg/BRuEw2gQUJ88At1wB75FgNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    mock
    pytest-xdist
    torchvision
  ];

  # runs successfully in 3.9, however, async isn't correctly closed so it will fail after test suite.
  doCheck = pythonOlder "3.9";

  enabledTestPaths = [
    "tests/"
  ];

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  # avoid tests which need special packages
  disabledTestPaths = [
    "tests/ignite/contrib/handlers/test_clearml_logger.py"
    "tests/ignite/contrib/handlers/test_lr_finder.py"
    "tests/ignite/contrib/handlers/test_trains_logger.py"
    "tests/ignite/metrics/nlp/test_bleu.py"
    "tests/ignite/metrics/nlp/test_rouge.py"
    "tests/ignite/metrics/gan" # requires pytorch_fid; tries to download model to $HOME
    "tests/ignite/metrics/test_dill.py"
    "tests/ignite/metrics/test_psnr.py"
    "tests/ignite/metrics/test_ssim.py"
  ];

  # disable tests which need specific packages
  disabledTests = [
    "idist"
    "mlflow"
    "tensorboard"
    "test_gpu_info" # needs pynvml
    "test_integration"
    "test_output_handler" # needs mlflow
    "test_pbar" # slight output differences
    "test_setup_clearml_logging"
    "test_setup_neptune"
    "test_setup_plx"
    "test_write_results"
    "trains"
    "visdom"
  ];

  pythonImportsCheck = [
    "ignite"
    "ignite.engine"
    "ignite.handlers"
    "ignite.metrics"
    "ignite.distributed"
    "ignite.exceptions"
    "ignite.utils"
    "ignite.contrib"
  ];

  meta = {
    description = "High-level training library for PyTorch";
    homepage = "https://pytorch-ignite.ai";
    changelog = "https://github.com/pytorch/ignite/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
