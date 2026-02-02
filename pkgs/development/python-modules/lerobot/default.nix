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
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "lerobot";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "lerobot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3z8gyK9bx5GpFXM/kLbxume/e8F2U84yUTUhmn57mLs=";
  };

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
    "wandb"
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
    pytest-timeout
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
    "test_convert_image_to_video_dataset"
    "test_convert_image_to_video_dataset_subset_episodes"
    "test_dataset_initialization"
    "test_factory"
    "test_from_pretrained_nonexistent_path"
    "test_load_config_nonexistent_path_tries_hub"
    "test_make_env_from_hub_async"
    "test_make_env_from_hub_with_trust"
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

    # TypeError: 'NoneType' object is not subscriptable
    "test_pi0_rtc_inference_with_prev_chunk"
  ];

  disabledTestPaths = [
    # Sometimes hang forever on some CPU models
    "tests/policies/test_sac_policy.py"

    # Sometimes hang forever
    "tests/policies/rtc/test_modeling_rtc.py"
  ];

  meta = {
    description = "Making AI for Robotics more accessible with end-to-end learning";
    homepage = "https://github.com/huggingface/lerobot";
    changelog = "https://github.com/huggingface/lerobot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
