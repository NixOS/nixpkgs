{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  appdirs,
  blinker,
  chromadb,
  click,
  instructor,
  json-repair,
  json5,
  jsonref,
  litellm,
  openai,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  openpyxl,
  pdfplumber,
  portalocker,
  pydantic,
  pydantic-settings,
  pyjwt,
  python-dotenv,
  pyvis,
  qdrant-client,
  regex,
  tokenizers,
  tomli,
  tomli-w,
  uv,

  # tests
  pytestCheckHook,
  pytest-xdist,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "crewai";
  version = "0.203.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crewAIInc";
    repo = "crewAI";
    tag = version;
    hash = "sha256-vy3JdJjuiFbi66IDNo+dQ7MZqlHqvHt/zUb6eblPT7A=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "chromadb"
    "json-repair"
    "litellm"
    "portalocker"
    "pydantic"
    "pyvis"
  ];

  dependencies = [
    appdirs
    blinker
    chromadb
    click
    instructor
    json-repair
    json5
    jsonref
    litellm
    openai
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    openpyxl
    pdfplumber
    portalocker
    pydantic
    pydantic-settings
    pyjwt
    python-dotenv
    pyvis
    regex
    tokenizers
    tomli
    tomli-w
    uv
  ];

  pythonImportsCheck = [ "crewai" ];

  disabledTestPaths = [
    # Ignore tests that require {mem0, chromadb, telemetry, security, test_agent}
    "tests/memory/test_external_memory.py" # require mem0ai
    "tests/storage/test_mem0_storage.py" # require mem0ai
    "tests/cli/test_git.py" # require git
    "tests/memory/test_short_term_memory.py" # require require API keys
    "tests/test_crew.py" # require require API keys
    "tests/rag/chromadb/test_client.py" # issue with chromadb
    "tests/telemetry/test_telemetry.py" # telemetry need network access

    # ImportError: cannot import name 'InitFrom' from 'qdrant_client.models'
    "tests/rag/qdrant/test_client.py"
  ];

  disabledTests = [
    # AssertionError - json-repair behaves differently since 0.52.0
    "test_safe_repair_json_unrepairable"
    "test_valid_action_parsing_with_curly_braces"

    # Tests parser
    "test_valid_action_parsing_with_special_characters"

    # Tests agent - require API keys (OpenAI, Anthropic, etc)
    "test_agent_custom_max_iterations"
    "test_agent_error_on_parsing_tool"
    "test_agent_execute_task_basic"
    "test_agent_execute_task_with_context"
    "test_agent_execute_task_with_custom_llm"
    "test_agent_execute_task_with_ollama"
    "test_agent_execute_task_with_tool"
    "test_agent_execution"
    "test_agent_execution_with_specific_tools"
    "test_agent_execution_with_tools"
    "test_agent_from_repository"
    "test_agent_from_repository_override_attributes"
    "test_agent_from_repository_with_invalid_tools"
    "test_agent_function_calling_llm"
    "test_agent_knowledege_with_crewai_knowledge"
    "test_agent_moved_on_after_max_iterations"
    "test_agent_powered_by_new_o_model_family_that_allows_skipping_tool"
    "test_agent_powered_by_new_o_model_family_that_uses_tool"
    "test_agent_remembers_output_format_after_using_tools_too_many_times"
    "test_agent_repeated_tool_usage"
    "test_agent_repeated_tool_usage_check_even_with_disabled_cache"
    "test_agent_respect_the_max_rpm_set"
    "test_agent_respect_the_max_rpm_set_over_crew_rpm"
    "test_agent_step_callback"
    "test_agent_use_specific_tasks_output_as_context"
    "test_agent_with_knowledge_sources"
    "test_agent_with_knowledge_with_no_crewai_knowledge"
    "test_agent_with_ollama_llama3"
    "test_agent_with_only_crewai_knowledge"
    "test_agent_without_max_rpm_respects_crew_rpm"
    "test_cache_hitting"
    "test_custom_llm_temperature_preservation"
    "test_custom_llm_with_langchain"
    "test_disabling_cache_for_agent"
    "test_do_not_allow_crewai_trigger_context_for_first_task_hierarchical"
    "test_ensure_first_task_allow_crewai_trigger_context_is_false_does_not_inject"
    "test_first_task_auto_inject_trigger"
    "test_first_time_user_trace_collection_user_accepts"
    "test_first_time_user_trace_collection_with_timeout"
    "test_first_time_user_trace_consolidation_logic"
    "test_get_knowledge_search_query"
    "test_handle_context_length_exceeds_limit_cli_no"
    "test_llm_call"
    "test_llm_call_with_all_attributes"
    "test_llm_call_with_ollama_llama3"
    "test_logging_tool_usage"
    "test_task_allow_crewai_trigger_context"
    "test_task_allow_crewai_trigger_context_no_payload"
    "test_task_without_allow_crewai_trigger_context"
    "test_tool_result_as_answer_is_the_final_answer_for_the_agent"
    "test_tool_usage_information_is_appended_to_agent"
    "test_trace_batch_marked_as_failed_on_finalize_error"

    # Tests lite agent - require API keys
    "test_guardrail_is_called_using_callable"
    "test_lite_agent_created_with_correct_parameters"
    "test_guardrail_reached_attempt_limit"
    "test_agent_output_when_guardrail_returns_base_model"
    "test_lite_agent_with_tools"
    "test_lite_agent_structured_output"
    "test_lite_agent_returns_usage_metrics"
    "test_guardrail_is_called_using_string"

    # Tests evaluation - require API keys
    "test_evaluate_current_iteration"
    "test_eval_lite_agent"
    "test_eval_specific_agents_from_crew"
    "test_failed_evaluation"

    # Tests knowledge - missing optional dependencies (docling, embedchain, pandas)
    "test_docling_source"
    "test_multiple_docling_sources"
    "test_excel_knowledge_source"

    # Test telemetry
    "test_telemetry_fails_due_connect_timeout"

    # Tests crew
    "test_task_tools_override_agent_tools"
    "test_crew_output_file_end_to_end"
    "test_conditional_task_last_task_when_conditional_is_true"
    "test_crew_with_failing_task_guardrails"
    "test_kickoff_for_each_single_input"
    "test_hierarchical_verbose_manager_agent"
    "test_crew_function_calling_llm"
    "test_replay_interpolates_inputs_properly"
    "test_manager_agent_delegating_to_all_agents"
    "test_crew_does_not_interpolate_without_inputs"
    "test_crew_creation"
    "test_delegation_is_not_enabled_if_there_are_only_one_agent"
    "test_tools_with_custom_caching"
    "test_api_calls_throttling"
    "test_multimodal_agent_describing_image_successfully"
    "test_warning_long_term_memory_without_entity_memory"
    "test_replay_with_context"
    "test_crew_verbose_output"
    "test_before_kickoff_callback"
    "test_hierarchical_verbose_false_manager_agent"
    "test_task_with_no_arguments"
    "test_replay_setup_context"
    "test_kickoff_for_each_multiple_inputs"
    "test_conditional_task_last_task_when_conditional_is_false"
    "test_crew_with_delegating_agents"
    "test_agents_do_not_get_delegation_tools_with_there_is_only_one_agent"
    "test_multimodal_agent_live_image_analysis"
    "test_hierarchical_process"
    "test_crew_kickoff_usage_metrics"
    "test_disabled_memory_using_contextual_memory"
    "test_ensure_exchanged_messages_are_propagated_to_external_memory"
    "test_agent_usage_metrics_are_captured_for_hierarchical_process"
    "test_crew_log_file_output"
    "test_before_kickoff_without_inputs"
    "test_cache_hitting_between_agents"
    "test_crew_kickoff_streaming_usage_metrics"
    "test_async_crews_thread_safety"
    "test_valid_action_parsing_with_unbalanced_quotes"
    "test_valid_action_parsing_with_angle_brackets"
    "test_valid_action_parsing_with_mixed_quotes"
    "test_valid_action_parsing_with_parentheses"
    "test_parsing_with_whitespace"
    "test_valid_action_parsing_special_characters"
    "test_parsing_with_special_characters"
    "test_valid_action_parsing_with_newlines"
    "test_valid_action_parsing_with_nested_quotes"
    "test_valid_action_parsing_with_quotes"
    "test_valid_action_parsing_with_escaped_characters"
    "test_create_crew"

    # Tests LLM - require API keys
    "test_llm_callback_replacement"
    "test_gemini_models"
    "test_llm_call_with_message_list"
    "test_gpt_4_1"
    "test_o3_mini_reasoning_effort_low"
    "test_handle_streaming_tool_calls"
    "test_llm_call_with_string_input"
    "test_llm_call_with_tool_and_string_input"
    "test_llm_call_with_string_input_and_callbacks"
    "test_llm_call_when_stop_is_unsupported"
    "test_handle_streaming_tool_calls_with_error"
    "test_o3_mini_reasoning_effort_medium"
    "test_llm_call_with_tool_and_message_list"
    "test_gemma3"
    "test_llm_call_when_stop_is_unsupported_when_additional_drop_params_is_provided"
    "test_o3_mini_reasoning_effort_high"
    "test_handle_streaming_tool_calls_no_available_functions"
    "test_handle_streaming_tool_calls_no_tools"

    # Test main - require git
    "test_publish_when_not_in_sync"

    # Tests project - require embedchain and API keys
    "test_before_kickoff_modification"
    "test_before_kickoff_with_none_input"
    "test_multiple_before_after_kickoff"
    "test_after_kickoff_modification"
    "test_internal_crew_with_mcp"

    # Tests task - require API keys
    "test_output_json_hierarchical"
    "test_output_pydantic_sequential"
    "test_no_inject_date"
    "test_increment_tool_errors"
    "test_task_execution_times"
    "test_custom_converter_cls"
    "test_save_task_output"
    "test_inject_date"
    "test_output_pydantic_hierarchical"
    "test_json_property_without_output_json"
    "test_task_interpolation_with_hyphens"
    "test_increment_delegations_for_hierarchical_process"
    "test_save_task_json_output"
    "test_output_pydantic_to_another_task"
    "test_output_json_dict_sequential"
    "test_inject_date_custom_format"
    "test_output_json_sequential"
    "test_output_json_to_another_task"
    "test_increment_delegations_for_sequential_process"
    "test_save_task_pydantic_output"
    "test_output_json_dict_hierarchical"
    "test_task_with_max_execution_time"
    "test_task_with_max_execution_time_exceeded"

    # Tests task guardrails
    "test_task_guardrail_process_output"
    "test_guardrail_when_an_error_occurs"
    "test_guardrail_emits_events"

    # Tests tools
    "test_delegate_work"
    "test_delegate_work_with_wrong_co_worker_variable"
    "test_ask_question_with_wrong_co_worker_variable"
    "test_ask_question"
    "test_delegate_work_withwith_coworker_as_array"
    "test_ask_question_with_coworker_as_array"
    "test_max_usage_count_is_respected"
    "test_async_tool_using_within_isolated_crew"
    "test_async_tool_using_decorator_within_flow"
    "test_async_tool_using_decorator_within_isolated_crew"
    "test_async_tool_within_flow"
    "test_ainvoke"

    # Tests tracing
    "test_trace_listener_disabled_when_env_false"
    "test_trace_listener_with_authenticated_user"
    "test_trace_listener_collects_crew_events"
    "test_trace_listener_ephemeral_batch"
    "test_events_collection_batch_manager"

    # Tests utilities
    "test_converter_with_llama3_2_model"
    "test_converter_with_llama3_1_model"
    "test_converter_with_nested_model"
    "test_convert_with_instructions"
    "test_crew_emits_start_kickoff_event"
    "test_crew_emits_test_kickoff_type_event"
    "test_crew_emits_start_task_event"
    "test_llm_emits_call_started_event"
    "test_register_handler_adds_new_handler"
    "test_multiple_handlers_for_same_event"
    "test_llm_emits_event_with_lite_agent"
    "test_tools_emits_finished_events"
    "test_agent_emits_execution_started_and_completed_events"
    "test_crew_emits_end_kickoff_event"
    "test_llm_emits_stream_chunk_events"
    "test_tools_emits_error_events"
    "test_crew_emits_end_task_event"
    "test_stream_llm_emits_event_with_task_and_agent_info"
    "test_llm_no_stream_chunks_when_streaming_disabled"
    "test_llm_emits_event_with_task_and_agent_info"

    # Tests qdrant
    "test_acreate_collection"
    "test_aget_or_create_collection_wrong_client_type"
    "test_aadd_documents_empty_list"
    "test_acreate_collection_already_exists"
    "test_aget_or_create_collection_existing"
    "test_aadd_documents_collection_not_exists"
    "test_acreate_collection_wrong_client_type"
    "test_aadd_documents"
    "test_aadd_documents_wrong_client_type"
    "test_asearch"
    "test_adelete_collection_not_exists"
    "test_asearch_with_filters"
    "test_adelete_collection_wrong_client_type"
    "test_asearch_collection_not_exists"
    "test_areset"
    "test_areset_no_collections"
    "test_aget_or_create_collection_new"
    "test_aadd_documents_with_doc_id"
    "test_asearch_wrong_client_type"
    "test_areset_wrong_client_type"
    "test_adelete_collection"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    qdrant-client
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Framework for orchestrating role-playing, autonomous AI agents";
    homepage = "https://github.com/crewAIInc/crewAI";
    changelog = "https://github.com/crewAIInc/crewAI/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "crewai";
  };
}
