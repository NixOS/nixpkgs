{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-xdist
, torchvision
, pythonOlder
, matplotlib
, mock
, packaging
, pytorch
, scikit-learn
, tqdm
}:

buildPythonPackage rec {
  pname = "ignite";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-KBEoMV9lwlEra4DiGDLgPb85+HrnK4Qiy3XYDa9hO3s=";
  };

  checkInputs = [ pytestCheckHook matplotlib mock pytest-xdist torchvision ];
  propagatedBuildInputs = [ packaging pytorch scikit-learn tqdm ];

  # runs succesfully in 3.9, however, async isn't correctly closed so it will fail after test suite.
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

  meta = with lib; {
    description = "High-level training library for PyTorch";
    homepage = "https://pytorch.org/ignite";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
