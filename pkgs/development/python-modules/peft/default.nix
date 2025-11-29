{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  accelerate,
  huggingface-hub,
  numpy,
  packaging,
  psutil,
  pyyaml,
  safetensors,
  torch,
  tqdm,
  transformers,

  # tests
  datasets,
  diffusers,
  parameterized,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "peft";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "peft";
    tag = "v${version}";
    hash = "sha256-LLV6fMFPh45IvNJv9totMYDoKAkZW/1Bx3qOlDTWMLA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    accelerate
    huggingface-hub
    numpy
    packaging
    psutil
    pyyaml
    safetensors
    torch
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "peft" ];

  nativeCheckInputs = [
    datasets
    diffusers
    parameterized
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  enabledTestPaths = [ "tests" ];

  # These tests fail when MPS devices are detected
  disabledTests = lib.optional stdenv.hostPlatform.isDarwin [
    "gpu"
    "test_save_load"
    "test_resume_training_model_with_topk_weights"
  ];

  disabledTestPaths = [
    # ValueError: Can't find 'adapter_config.json'
    "tests/test_config.py"

    # Require internet access to download a dataset
    "tests/test_adaption_prompt.py"
    "tests/test_arrow.py"
    "tests/test_auto.py"
    "tests/test_boft.py"
    "tests/test_cpt.py"
    "tests/test_custom_models.py"
    "tests/test_decoder_models.py"
    "tests/test_encoder_decoder_models.py"
    "tests/test_feature_extraction_models.py"
    "tests/test_helpers.py"
    "tests/test_hub_features.py"
    "tests/test_incremental_pca.py"
    "tests/test_initialization.py"
    "tests/test_lora_variants.py"
    "tests/test_mixed.py"
    "tests/test_multitask_prompt_tuning.py"
    "tests/test_other.py"
    "tests/test_poly.py"
    "tests/test_stablediffusion.py"
    "tests/test_trainable_tokens.py"
    "tests/test_tuners_utils.py"
    "tests/test_vision_models.py"
    "tests/test_xlora.py"
    "tests/test_target_parameters.py"
    "tests/test_seq_classifier.py"
    "tests/test_low_level_api.py"
  ];

  meta = {
    homepage = "https://github.com/huggingface/peft";
    description = "State-of-the art parameter-efficient fine tuning";
    changelog = "https://github.com/huggingface/peft/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
