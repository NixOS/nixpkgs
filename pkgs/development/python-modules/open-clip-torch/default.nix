{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  ftfy,
  huggingface-hub,
  protobuf,
  regex,
  safetensors,
  sentencepiece,
  tiktoken,
  timm,
  torch,
  torchvision,
  tqdm,

  # tests
  braceexpand,
  pandas,
  pytestCheckHook,
  requests,
  transformers,
  webdataset,
}:
buildPythonPackage (finalAttrs: {
  pname = "open-clip-torch";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlfoundations";
    repo = "open_clip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z78Xd+PBsBHE2TU5rFLLbdrEmaYHcQ/wWgBiON2CaqQ=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    ftfy
    huggingface-hub
    protobuf
    regex
    safetensors
    sentencepiece
    tiktoken
    timm
    torch
    torchvision
    tqdm
  ];

  nativeCheckInputs = [
    braceexpand
    pandas
    pytestCheckHook
    requests
    transformers
    webdataset
  ];

  pythonImportsCheck = [ "open_clip" ];

  disabledTestPaths = [
    # -> On Darwin:
    # AttributeError: Can't pickle local object 'build_params.<locals>.<lambda>'
    # -> On Linux:
    # KeyError: Caught KeyError in DataLoader worker process 0
    "tests/test_wds.py"
  ];

  disabledTests = [
    # requires network
    "test_audio_naflex_batch_via_scheduler_feeds_model"
    "test_coca_roberta_pad_id"
    "test_create_optimizer_unwrap_preserves_name_matching"
    "test_download_pretrained_from_hfh"
    "test_end_to_end_naflex_pipeline"
    "test_genlap_tokenizer_is_tiktoken"
    "test_get_tokenizer_generative_validation_builtin_configs"
    "test_get_tokenizer_hub_branch_applies_legacy_mammut_shim"
    "test_get_wds_audio_dataset_naflex_genlap_feeds_model"
    "test_hf_hub_tiktoken_uses_exported_asset"
    "test_inference_simple"
    "test_inference_with_data"
    "test_local_dir_tiktoken_asset_paths_are_valid_model_cfg_fields"
    "test_local_dir_tiktoken_uses_exported_asset"
    "test_mammut_modern_factory_create"
    "test_modern_text_tiktoken_config_builds_model_and_tokenizer"
    "test_pretrained_text_encoder"
    "test_push_to_hf_hub_tiktoken_deletes_stale_hf_tokenizer_files"
    "test_random_transformers_clap_state_dict_loads_into_native"
    "test_save_for_hf_tiktoken_does_not_write_hf_clip_tokenizer_files"
    "test_tiktoken_clean_option"
    "test_tiktoken_gapped_vocab_export_round_trips"
    "test_tiktoken_native_specials_and_gap_ids"
    "test_tiktoken_special_token_controls"
    "test_tiktoken_tokenizer"
    "test_tiktoken_tokenizer_output_mask"
    "test_training_mt5"

    # fails due to type errors
    "test_num_shards"

    # KeyError: fname
    "test_fixed_training_epoch_counts"
    "test_get_wds_dataset_naflex_keeps_dictionary_contract"
    "test_get_wds_dataset_naflex_rolls_over_non_resampled_input"
    "test_legacy_wds_audio"
    "test_legacy_wds_image_fixed_text"
    "test_legacy_wds_image_variable_text"
    "test_only_budget_trait_charges_captions_to_naflex_rows"

    # hangs forever
    "test_training"
  ];

  meta = {
    description = "Open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    changelog = "https://github.com/mlfoundations/open_clip/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "open-clip";
  };
})
