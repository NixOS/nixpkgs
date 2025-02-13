{
  lib,
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
  version = "0.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmengine";
    tag = "v${version}";
    hash = "sha256-J9p+JCtNoBlBvvv4p57/DHUIifYs/jdo+pK+paD+iXI=";
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
    bitsandbytes
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
      export HOME=$(mktemp -d)
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

  meta = {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
