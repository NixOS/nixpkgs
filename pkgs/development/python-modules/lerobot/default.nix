{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,

  # dependencies
  draccus,
  einops,
  gymnasium,
  huggingface-hub,
  numpy,
  opencv-python-headless,
  packaging,
  pillow,
  requests,
  safetensors,
  termcolor,
  torch,
  torchcodec,
  torchvision,
  tqdm,

  # tests
  av,
  datasets,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lerobot";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "lerobot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-glTeELaebo5C6RethwYIHF4gB7CgKZlPr4wf45ih9cs=";
  };

  build-system = [
    cmake
    setuptools
  ];
  dontUseCmakeConfigure = true;

  pythonRelaxDeps = [
    "draccus"
    "numpy"
    "packaging"
    "torch"
    "torchvision"
  ];
  dependencies = [
    draccus
    einops
    gymnasium
    huggingface-hub
    numpy
    opencv-python-headless
    packaging
    pillow
    requests
    safetensors
    termcolor
    torch
    torchcodec
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "lerobot" ];

  nativeCheckInputs = [
    av
    datasets
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires internet access
    "test_act_backbone_lr"
    "test_backward_compatibility"
    "test_convert_image_to_video_dataset"
    "test_convert_image_to_video_dataset_subset_episodes"
    "test_factory"
    "test_make_env_from_hub_async"
    "test_make_env_from_hub_with_trust"
    "test_policy_defaults"
    "test_save_and_load_pretrained"
    "test_save_pretrained_with_state_dict"

    # Hang indefinitely
    "test_aggregate_datasets"
    "test_aggregate_with_low_threshold"

    # RuntimeError: SingleStreamDecoder, /build/source/src/torchcodec/_core/SingleStreamDecoder.cpp:80,
    # Failed to open input buffer: Invalid data found when processing input
    "TestVideoDecoderCacheBounded"

    # ValueError: pix_fmt='yuv420p' is not supported by codec 'h264_vaapi'; supported pixel formats: ['vaapi']
    "test_vaapi_options"

    # draccus.utils.ParsingError: Expected a dict with a 'type' key for ...
    "test_reward_model_config_from_pretrained_roundtrip"

    # TypeError: cannot create weak reference to 'str' object
    "test_save_pretrained_round_trip_via_disk"

    # [Errno 1094995529] Invalid data found when processing input: '/build/source/tests/artifacts/encoded_videos/clip_4frames.mp4'
    "test_depth_encoder_config_sets_is_depth_map_true"
    "test_geometry_preserved"
    "test_merges_encoder_config_as_video_prefixed_entries"
    "test_reencode_video"
    "test_reencode_video_trim_window"
    "test_returns_all_stream_fields"
    "test_stream_derived_keys_take_precedence_over_config"
    "test_three_clips_frame_count"
    "test_two_clips_frame_count"

    # RuntimeError: OpenCVCamera(/build/source/tests/artifacts/cameras/image_480x270.png) read failed
    "test_async_read"
    "test_fourcc_with_camer"
    "test_read"
    "test_rotation"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: Failed to initialize cpuinfo!
    "test_complementary_data_float_dtype_conversion"
    "test_float_dtype_conversion"
    "test_float_dtype_with_mixed_tensors"

    # AssertionError: assert 'f7566ea964d1...371ef6c23b64f' == 'c17e47af68a8...095018561ae9e'
    "test_groot_n1_7_eval_image_transform_matches_oss_reference"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # gRPC fails to connect on loopback in sandbox despite __darwinAllowLocalNetworking
    "test_end_to_end_interactions_flow"
    "test_end_to_end_parameters_flow"
    "test_end_to_end_transitions_flow"
  ];

  disabledTestPaths = [
    # Require internet access
    # httpx.ConnectError: [Errno -3] Temporary failure in name resolution
    "tests/policies/test_relative_actions.py"

    # Sometimes hang forever
    "tests/policies/rtc/test_modeling_rtc.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Making AI for Robotics more accessible with end-to-end learning";
    homepage = "https://github.com/huggingface/lerobot";
    changelog = "https://github.com/huggingface/lerobot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
