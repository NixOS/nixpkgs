{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  jinja2,
  openai,
  orjson,
  pydantic,
  requests,
  rich,

  # tests
  anthropic,
  google-genai,
  htmltools,
  matplotlib,
  pillow,
  pytest-asyncio,
  pytest-snapshot,
  pytestCheckHook,
  tenacity,
}:

buildPythonPackage rec {
  pname = "chatlas";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "chatlas";
    tag = "v${version}";
    hash = "sha256-uCgpNvDJZKwxX4HYF8tyvJ1AiQLmybuxrZkYK/u5xlg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    jinja2
    openai
    orjson
    pydantic
    requests
    rich
  ];

  pythonImportsCheck = [ "chatlas" ];

  nativeCheckInputs = [
    anthropic
    google-genai
    htmltools
    matplotlib
    pillow
    pytest-asyncio
    pytest-snapshot
    pytestCheckHook
    tenacity
  ];

  disabledTestPaths = [
    # Require an Openai API key and/or internet access
    "tests/test_batch_chat.py"
    "tests/test_content.py"
    "tests/test_provider_anthropic.py"
    "tests/test_provider_azure.py"
    "tests/test_provider_databricks.py"
    "tests/test_provider_google.py"
    "tests/test_provider_openai.py"
    "tests/test_provider_snowflake.py"
    "tests/test_register_tool_models.py"
  ];

  disabledTests = [
    # Require an Openai API key
    "test_async_tool_yielding_multiple_results"
    "test_basic_export"
    "test_basic_repr"
    "test_basic_str"
    "test_chat_callbacks"
    "test_chat_structured"
    "test_chat_structured_async"
    "test_chat_tool_request_reject"
    "test_chat_tool_request_reject2"
    "test_compute_cost"
    "test_content_tool_request_serializable"
    "test_cross_provider_compatibility"
    "test_deepcopy_chat"
    "test_get_token_prices"
    "test_get_tools_after_registration"
    "test_get_tools_empty"
    "test_google_provider_model_params"
    "test_google_provider_parameter_mapping"
    "test_invoke_tool_returns_tool_result"
    "test_json_serialize"
    "test_last_turn_retrieval"
    "test_model_params_integration_with_provider"
    "test_model_params_kwargs_priority"
    "test_model_params_preserved_across_calls"
    "test_modify_system_prompt"
    "test_old_style_tool_invocation_still_works"
    "test_parameter_validation_edge_cases"
    "test_provider_parameter_differences"
    "test_register_tool"
    "test_register_tool_duplicate_name_error"
    "test_register_tool_force_overwrite"
    "test_register_tool_instance_basic"
    "test_register_tool_instance_force_overwrite"
    "test_register_tool_instance_with_custom_name"
    "test_register_tool_instance_with_model_override"
    "test_register_tool_with_complex_parameters"
    "test_register_tool_with_custom_name"
    "test_register_tool_with_same_name_different_function"
    "test_set_model_params_all_parameters"
    "test_set_model_params_basic"
    "test_set_model_params_empty_call"
    "test_set_model_params_incremental_updates"
    "test_set_model_params_invalid_temperature"
    "test_set_model_params_invalid_top_p"
    "test_set_model_params_kwargs"
    "test_set_model_params_kwargs_replacement"
    "test_set_model_params_missing_values"
    "test_set_model_params_multiple_unsupported"
    "test_set_model_params_none_reset"
    "test_set_model_params_reset_specific_param"
    "test_set_model_params_type_validation"
    "test_set_model_params_unsupported_parameter"
    "test_set_model_params_updates_existing"
    "test_set_model_params_with_stop_sequences"
    "test_set_tools_mixed"
    "test_set_tools_replaces_existing"
    "test_set_tools_with_functions"
    "test_set_tools_with_tool_objects"
    "test_simple_async_batch_chat"
    "test_simple_batch_chat"
    "test_simple_streaming_chat"
    "test_simple_streaming_chat_async"
    "test_supported_model_params_openai"
    "test_system_prompt_retrieval"
    "test_token_count_method"
    "test_tokens_method"
    "test_tool_custom_result"
    "test_tool_yielding_content_tool_results"
    "test_tool_yielding_multiple_results"
    "test_tool_yielding_single_result_still_works"
    "test_tool_yielding_with_error"
    "test_translate_model_params_openai"
    "test_unknown_tool_error_format_updated"
  ];

  meta = {
    description = "Friendly guide to building LLM chat apps in Python with less effort and more clarity";
    homepage = "https://posit-dev.github.io/chatlas";
    downloadPage = "https://github.com/posit-dev/chatlas";
    changelog = "https://github.com/posit-dev/chatlas/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
