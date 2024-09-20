{
  lib,
  addict,
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  lmdb,
  matplotlib,
  mlflow,
  numpy,
  opencv4,
  parameterized,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich,
  setuptools,
  stdenv,
  termcolor,
  torch,
  yapf,
}:

buildPythonPackage rec {
  pname = "mmengine";
  version = "0.10.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmengine";
    rev = "refs/tags/v${version}";
    hash = "sha256-+YDtYHp3BwKvzhmHC6hAZ3Qtc9uRZMo/TpWqdpm2hn0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    addict
    matplotlib
    numpy
    opencv4
    pyyaml
    rich
    termcolor
    yapf
  ];

  nativeCheckInputs = [
    coverage
    lmdb
    mlflow
    parameterized
    pytestCheckHook
    torch
  ];

  preCheck =
    ''
      export HOME=$TMPDIR
    ''
    # Otherwise, the backprop hangs forever. More precisely, this exact line:
    # https://github.com/open-mmlab/mmengine/blob/02f80e8bdd38f6713e04a872304861b02157905a/tests/test_runner/test_activation_checkpointing.py#L46
    # Solution suggested in https://github.com/pytorch/pytorch/issues/91547#issuecomment-1370011188
    + ''
      export MKL_NUM_THREADS=1
    '';

  pythonImportsCheck = [ "mmengine" ];

  disabledTestPaths = [
    # AttributeError
    "tests/test_fileio/test_backends/test_petrel_backend.py"
    # Freezes forever?
    "tests/test_runner/test_activation_checkpointing.py"
    # missing dependencies
    "tests/test_visualizer/test_vis_backend.py"
  ];

  disabledTests = [
    # Tests are disabled due to sandbox
    "test_fileclient"
    "test_http_backend"
    "test_misc"
    # RuntimeError
    "test_dump"
    "test_deepcopy"
    "test_copy"
    "test_lazy_import"
    # AssertionError
    "test_lazy_module"
    # Require unpackaged aim
    "test_experiment"
    "test_add_config"
    "test_add_image"
    "test_add_scalar"
    "test_add_scalars"
    "test_close"
  ];

  meta = with lib; {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ rxiao ];
    broken = stdenv.isDarwin || (stdenv.isLinux && stdenv.isAarch64);
  };
}
