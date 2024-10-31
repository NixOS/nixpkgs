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
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J0xrqAGwH0bAs59T7zA8irMWOGbE2+Zd9kwqxYUYYMA=";
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

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  # avoid tests which need special packages
  pytestFlagsArray = [
    "--ignore=tests/ignite/contrib/handlers/test_clearml_logger.py"
    "--ignore=tests/ignite/contrib/handlers/test_lr_finder.py"
    "--ignore=tests/ignite/contrib/handlers/test_trains_logger.py"
    "--ignore=tests/ignite/metrics/nlp/test_bleu.py"
    "--ignore=tests/ignite/metrics/nlp/test_rouge.py"
    "--ignore=tests/ignite/metrics/gan" # requires pytorch_fid; tries to download model to $HOME
    "--ignore=tests/ignite/metrics/test_dill.py"
    "--ignore=tests/ignite/metrics/test_psnr.py"
    "--ignore=tests/ignite/metrics/test_ssim.py"
    "tests/"
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
    changelog = "https://github.com/pytorch/ignite/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
    # ModuleNotFoundError: No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package
    broken = stdenv.hostPlatform.isDarwin;
  };
}
