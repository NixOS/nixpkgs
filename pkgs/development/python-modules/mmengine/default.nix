{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  addict,
  matplotlib,
  numpy,
  opencv4,
  pyyaml,
  rich,
  termcolor,
  yapf,

  # checks
  bitsandbytes,
  coverage,
  dvclive,
  lion-pytorch,
  lmdb,
  mlflow,
  parameterized,
  pytestCheckHook,
  transformers,
}:

buildPythonPackage rec {
  pname = "mmengine";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmengine";
    rev = "refs/tags/v${version}";
    hash = "sha256-bZ6O4UOYUCwq11YmgRWepOIngYxYD/fNfM/VmcyUv9k=";
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
    # bitsandbytes (broken as of 2024-07-06)
    coverage
    dvclive
    lion-pytorch
    lmdb
    mlflow
    parameterized
    pytestCheckHook
    transformers
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
    # Tests are outdated (runTest instead of run_test)
    "mmengine/testing/_internal"
    "tests/test_dist/test_dist.py"
    "tests/test_dist/test_utils.py"
    "tests/test_hooks/test_sync_buffers_hook.py"
    "tests/test_model/test_wrappers/test_model_wrapper.py"
    "tests/test_optim/test_optimizer/test_optimizer.py"
    "tests/test_optim/test_optimizer/test_optimizer_wrapper.py"
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

  meta = {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ rxiao ];
    broken =
      stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
