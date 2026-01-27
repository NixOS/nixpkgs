{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  filelock,
  fonttools,
  huggingface-hub,
  matplotlib,
  mlx,
  numpy,
  opencv-python,
  piexif,
  pillow,
  platformdirs,
  regex,
  requests,
  safetensors,
  sentencepiece,
  tokenizers,
  toml,
  torch,
  tqdm,
  transformers,
  twine,
  urllib3,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mflux";
  version = "0.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "filipstrand";
    repo = "mflux";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-rubwj4/XCUajnr1wp64rnzbvS+yXt9zbG6eT+DXEdko=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.19,<0.8.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonRelaxDeps = [
    "huggingface-hub"
    "mlx"
    "pillow"
    "transformers"
  ];
  dependencies = [
    filelock
    fonttools
    huggingface-hub
    matplotlib
    mlx
    numpy
    opencv-python
    piexif
    pillow
    platformdirs
    regex
    requests
    safetensors
    sentencepiece
    tokenizers
    toml
    torch
    tqdm
    transformers
    twine
    urllib3
  ];

  pythonImportsCheck = [ "mflux" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Require internet access
    "test_concept_attention_from_image"
    "test_concept_attention_generation"
    "test_empty_stdin_fails_generation"
    "test_fill"
    "test_flux2_klein_9b_edit_dalmatian"
    "test_flux2_klein_9b_edit_glasses_wide"
    "test_flux2_klein_9b_edit_sunglasses_wide"
    "test_flux2_klein_9b_text_to_image"
    "test_flux2_klein_text_to_image"
    "test_ic_edit_with_instruction"
    "test_image_generation_dev"
    "test_image_generation_dev_controlnet"
    "test_image_generation_dev_image_to_image"
    "test_image_generation_dev_lora"
    "test_image_generation_dev_lora_controlnet"
    "test_image_generation_dev_multiple_loras"
    "test_image_generation_fibo"
    "test_image_generation_fibo_refined_white_owl"
    "test_image_generation_kontext"
    "test_image_generation_qwen_edit"
    "test_image_generation_qwen_edit_multiple_images"
    "test_image_generation_redux"
    "test_image_generation_schnell"
    "test_image_generation_schnell_controlnet"
    "test_image_generation_with_reference_image"
    "test_image_generation_z_image_turbo"
    "test_image_generation_z_image_turbo_lora"
    "test_image_upscaling"
    "test_in_context_lora_identity"
    "test_metadata_complete"
    "test_pipe_from_echo_command"
    "test_qwen_image_generation_image_to_image"
    "test_qwen_image_generation_lora"
    "test_qwen_image_generation_text_to_image"
    "test_resume_training"
    "test_save_and_load_4bit_model"
    "test_save_and_load_4bit_model_with_lora"
    "test_save_with_lora_has_same_shard_count_as_base"
    "test_seedvr2_upscale"
    "test_stdin_prompt_multiline_with_actual_generation"
    "test_stdin_prompt_with_actual_generation"
    "test_train_and_load_weights"
    "test_vlm_generate_json"
    "test_vlm_inspire_json_from_image"
    "test_vlm_inspire_json_from_image_with_prompt"
    "test_vlm_refine_json_text_only"

    # Hangs indefinitely
    "test_real_vae_tiling_compatibility"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs indefinitely
    "test_depth_pro_generation"
  ];

  meta = {
    description = "MLX native implementations of state-of-the-art generative image models";
    homepage = "https://github.com/filipstrand/mflux";
    changelog = "https://github.com/filipstrand/mflux/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
