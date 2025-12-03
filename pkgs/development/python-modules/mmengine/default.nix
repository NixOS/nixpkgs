{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  addict,
  distutils,
  matplotlib,
  numpy,
  opencv4,
  pyyaml,
  rich,
  termcolor,
  yapf,

  # tests
  bitsandbytes,
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

  patches = [
    # Explicitly disable weights_only in torch.load calls
    # https://github.com/open-mmlab/mmengine/pull/1650
    (fetchpatch {
      name = "torch-2.6.0-compat.patch";
      url = "https://github.com/open-mmlab/mmengine/pull/1650/commits/c21b8431b2c625560a3866c65328cff0380ba1f8.patch";
      hash = "sha256-SLr030IdYD9wM/jPJuZd+Dr1jjFx/5/YkJj/IwhnNQg=";
    })
  ];

  postPatch =
    # Fails in python >= 3.13
    # exec(compile(f.read(), version_file, "exec")) does not populate the locals() namesp
    # In python 3.13, the locals() dictionary in a function does not automatically update with
    # changes made by exec().
    # https://peps.python.org/pep-0558/
    ''
      substituteInPlace setup.py \
        --replace-fail \
          "return locals()['__version__']" \
          "return '${version}'"
    ''
    + ''
      substituteInPlace tests/test_config/test_lazy.py \
        --replace-fail "import numpy.compat" ""
    '';

  build-system = [ setuptools ];

  dependencies = [
    addict
    distutils
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

  disabledTestPaths = [
    # Require unpackaged aim
    "tests/test_visualizer/test_vis_backend.py::TestAimVisBackend"

    # Cannot find SSL certificate
    # _pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)
    "tests/test_visualizer/test_vis_backend.py::TestDVCLiveVisBackend"

    # AttributeError: type object 'MagicMock' has no attribute ...
    "tests/test_fileio/test_backends/test_petrel_backend.py::TestPetrelBackend"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: attempt to insert nil object from objects[1]
    "tests/test_visualizer/test_visualizer.py::TestVisualizer::test_draw_featmap"
    "tests/test_visualizer/test_visualizer.py::TestVisualizer::test_show"

    # AssertionError: torch.bfloat16 != torch.float32
    "tests/test_runner/test_amp.py::TestAmp::test_autocast"

    # ValueError: User specified autocast device_type must be cuda or cpu, but got mps
    "tests/test_runner/test_runner.py::TestRunner::test_test"
    "tests/test_runner/test_runner.py::TestRunner::test_val"

    # Fails in pytestCheckHook due to multiple copies accessing the same resources (nixpkgs-review
    "tests/test_hooks/test_ema_hook.py::TestEMAHook::test_after_test_epoch"
    "tests/test_hooks/test_ema_hook.py::TestEMAHook::test_after_val_epoch"
    "tests/test_hooks/test_ema_hook.py::TestEMAHook::test_before_test_epoch"
    "tests/test_hooks/test_ema_hook.py::TestEMAHook::test_before_val_epoch"
    "tests/test_infer/test_infer.py"
    "tests/test_runner/test_runner.py::TestRunner::test_checkpoint"

    # torch.distributed.DistNetworkError: [...] message: address already in use
    # Happens in nixpkgs-review due to the lack of network namespacing
    # Note: These all worked fine in nix-build
    "tests/test_dist/test_dist.py"
    "tests/test_dist/test_utils.py" # fails in _init_dist_env
    "tests/test_hooks/test_sync_buffers_hook.py::TestSyncBuffersHook::test_sync_buffers_hook"
    "tests/test_model/test_model_utils.py::test_is_model_wrapper"
    "tests/test_model/test_wrappers/test_model_wrapper.py::TestDistributedDataParallel"
    "tests/test_optim/test_optimizer/test_optimizer.py::TestZeroOptimizer::test_zero_redundancy_optimizer"
    "tests/test_runner/test_runner.py::TestRunner::test_custom_loop"
    "tests/test_runner/test_runner.py::TestRunner::test_default_scope"
    "tests/test_runner/test_runner.py::TestRunner::test_init"
    "tests/test_runner/test_runner.py::TestRunner::test_train"
    "tests/test_optim/test_optimizer/test_optimizer_wrapper.py::TestOptimWrapper::test_optim_context"
    "tests/test_testing/test_runner_test_case.py"

    # TypeError: 'BaseDataset' object is not callable
    "tests/test_dataset/test_base_dataset.py::TestBaseDataset::test_get_subset[False-True]"
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails when max-jobs is set to use fewer processes than cores
    # for example `AssertionError: assert 14 == 4`
    "test_setup_multi_processes"

    # Crashes in pytestCheckHook due to MPS incompatibility in torch
    "test_with_runner"
  ];

  meta = {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
