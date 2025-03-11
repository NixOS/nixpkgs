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

  # tests
  bitsandbytes,
  coverage,
  dvclive,
  lion-pytorch,
  lmdb,
  mlflow,
  parameterized,
  pytestCheckHook,
  transformers,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "mmengine";
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmengine";
    tag = "v${version}";
    hash = "sha256-hQnwenuxHQwl+DwQXbIfsKlJkmcRvcHV1roK7q2X1KA=";
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

  pythonImportsCheck = [ "mmengine" ];

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
    writableTmpDirAsHomeHook
  ];

  preCheck =
    # Otherwise, the backprop hangs forever. More precisely, this exact line:
    # https://github.com/open-mmlab/mmengine/blob/02f80e8bdd38f6713e04a872304861b02157905a/tests/test_runner/test_activation_checkpointing.py#L46
    # Solution suggested in https://github.com/pytorch/pytorch/issues/91547#issuecomment-1370011188
    ''
      export MKL_NUM_THREADS=1
    '';

  pytestFlagsArray = [
    # Require unpackaged aim
    "--deselect tests/test_visualizer/test_vis_backend.py::TestAimVisBackend"

    # Cannot find SSL certificate
    # _pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)
    "--deselect tests/test_visualizer/test_vis_backend.py::TestDVCLiveVisBackend"

    # AttributeError: type object 'MagicMock' has no attribute ...
    "--deselect tests/test_fileio/test_backends/test_petrel_backend.py::TestPetrelBackend"
  ];

  disabledTests = [
    # Require network access
    "test_fileclient"
    "test_http_backend"
    "test_misc"

    # RuntimeError
    "test_dump"
    "test_deepcopy"
    "test_copy"
    "test_lazy_import"

    # AssertionError: os is not <module 'os' (frozen)>
    "test_lazy_module"
  ];

  meta = {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
