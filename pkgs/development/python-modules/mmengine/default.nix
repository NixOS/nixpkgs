{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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

  patches = [
    (fetchpatch2 {
      name = "mmengine-torch-2.5-compat.patch";
      url = "https://github.com/open-mmlab/mmengine/commit/4c22f78cdea2981a2b48a167e9feffe4721f8901.patch";
      hash = "sha256-k+IFLeqTEVUGGiqmZg56LK64H/UTvpGN20GJT59wf4A=";
    })
    (fetchpatch2 {
      # Bug reported upstream in https://github.com/open-mmlab/mmengine/issues/1575
      # PR: https://github.com/open-mmlab/mmengine/pull/1589
      name = "adapt-to-pytest-breaking-change";
      url = "https://patch-diff.githubusercontent.com/raw/open-mmlab/mmengine/pull/1589.patch";
      hash = "sha256-lyKf1GCLOPMpDttJ4s9hbATIGCVkiQhtyLfH9WzMWrw=";
    })
  ];

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
    broken =
      stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
