{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,

  # dependencies
  accelerate,
  av,
  datasets,
  deepdiff,
  diffusers,
  draccus,
  einops,
  flask,
  gymnasium,
  huggingface-hub,
  imageio,
  jsonlines,
  opencv-python-headless,
  packaging,
  pynput,
  pyserial,
  rerun-sdk,
  termcolor,
  torch,
  torchcodec,
  torchvision,
  wandb,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "lerobot";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "lerobot";
    tag = "v${version}";
    hash = "sha256-RVe1X0qBPm+okO3Gi/UdkuvuX0m4RlbhIs+NJLlC9wU=";
  };

  # ValueError: mutable default <class 'lerobot.configs.types.PolicyFeature'> for field value is not allowed: use default_factory
  postPatch = ''
    substituteInPlace tests/processor/test_pipeline.py \
      --replace-fail \
        "from dataclasses import dataclass" \
        "from dataclasses import dataclass, field" \
      --replace-fail \
        "value: PolicyFeature = PolicyFeature(type=FeatureType.STATE, shape=(1,))" \
        "value: PolicyFeature = field(default_factory=lambda: PolicyFeature(type=FeatureType.STATE, shape=(1,)))"
  '';

  build-system = [
    cmake
    setuptools
  ];
  dontUseCmakeConfigure = true;

  pythonRelaxDeps = [
    "av"
    "datasets"
    "draccus"
    "gymnasium"
    "rerun-sdk"
    "torch"
    "torchvision"
  ];

  dependencies = [
    accelerate
    av
    cmake
    datasets
    deepdiff
    diffusers
    draccus
    einops
    flask
    gymnasium
    huggingface-hub
    imageio
    jsonlines
    opencv-python-headless
    packaging
    pynput
    pyserial
    rerun-sdk
    termcolor
    torch
    torchcodec
    torchvision
    wandb
  ]
  ++ imageio.optional-dependencies.ffmpeg
  ++ huggingface-hub.optional-dependencies.hf_transfer
  ++ huggingface-hub.optional-dependencies.cli;

  pythonImportsCheck = [ "lerobot" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # RuntimeError: OpenCVCamera(/build/source/tests/artifacts/cameras/image_480x270.png) read failed
    "test_async_read"
    "test_fourcc_with_camer"
    "test_read"
    "test_rotation"

    # Require internet access
    "test_act_backbone_lr"
    "test_backward_compatibility"
    "test_dataset_initialization"
    "test_factory"
    "test_from_pretrained_nonexistent_path"
    "test_policy_defaults"
    "test_save_and_load_pretrained"

    # TypeError: stack(): argument 'tensors' (position 1) must be tuple of Tensors, not Column
    "test_check_timestamps_sync_slightly_off"
    "test_check_timestamps_sync_synced"
    "test_check_timestamps_sync_unsynced"
    "test_check_timestamps_sync_unsynced_no_exception"
    "test_compute_sampler_weights_drop_n_last_frames"
    "test_compute_sampler_weights_nontrivial_ratio"
    "test_compute_sampler_weights_nontrivial_ratio_and_drop_last_n"
    "test_compute_sampler_weights_trivial"
    "test_record_and_replay"
    "test_record_and_resume"
    "test_same_attributes_defined"

    # AssertionError between two dicts. One has an extra `'_is_initial': False` entry.
    "test_cosine_decay_with_warmup_scheduler"
    "test_diffuser_scheduler"
    "test_vqbet_scheduler"

    # AssertionError: Regex pattern did not match.
    #  Regex: "Can't instantiate abstract class NonCallableStep with abstract method __call_"
    #  Input: "Can't instantiate abstract class NonCallableStep without an implementation for abstract method '__call__'"
    "test_construction_rejects_step_without_call"
  ];

  disabledTestPaths = [
    # Sometimes hang forever on some CPU models
    "tests/policies/test_sac_policy.py"
  ];

  meta = {
    description = "Making AI for Robotics more accessible with end-to-end learning";
    homepage = "https://github.com/huggingface/lerobot";
    changelog = "https://github.com/huggingface/lerobot/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
