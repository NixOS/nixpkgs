{
  lib,
  aiohttp,
  aiosqlite,
  asyncpg,
  boto3,
  buildPythonPackage,
  cbor2,
  cryptography,
  docker,
  e2b-code-interpreter,
  e2b,
  fastapi,
  fetchPypi,
  filelock,
  graphviz,
  griffelib,
  grpcio,
  h2,
  hatchling,
  inline-snapshot,
  litellm,
  mcp,
  modal,
  numpy,
  openai,
  protobuf,
  pydantic,
  pygments,
  pymongo,
  pytest-asyncio,
  pytestCheckHook,
  redis,
  requests,
  sqlalchemy,
  temporalio,
  textual,
  typing-extensions,
  twilio,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.26.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-fyM3aDACJmACpIfc2QmBIGcqRxycnS0hhCFrDKiQcK4=";
  };

  pythonRelaxDeps = [
    "openai"
    "urllib3"
  ];

  build-system = [ hatchling ];

  dependencies = [
    griffelib
    mcp
    openai
    pydantic
    requests
    typing-extensions
    websockets
  ];

  optional-dependencies = {
    voice = [
      numpy
      websockets
    ];
    viz = [ graphviz ];
    litellm = [
      litellm
      aiohttp
      filelock
    ];
    # any-llm = [
    #  any-llm-sdk
    #  pygments
    # ];
    realtime = [ websockets ];
    sqlalchemy = [
      sqlalchemy
      asyncpg
    ]
    ++ sqlalchemy.optional-dependencies.asyncio;
    encrypt = [ cryptography ];
    redis = [ redis ];
    # dapr = [
    #   dapr
    #   grpcio
    #   aiohttp
    #   protobuf
    # ];
    mongodb = [ pymongo ];
    docker = [ docker ];
    # blaxel = [
    #   blaxel
    #   aiohttp
    # ];
    # daytona = [
    #   daytona
    #   aiohttp
    #   protobuf
    # ];
    cloudflare = [ aiohttp ];
    e2b = [
      e2b
      e2b-code-interpreter
      h2
      protobuf
      pygments
    ];
    modal = [
      modal
      aiohttp
      cbor2
      h2
      protobuf
      pygments
    ];
    # vercel = [
    #   vercel-sandbox
    #   cbor2
    # ];
    s3 = [ boto3 ];
    temporal = [
      temporalio
      textual
      protobuf
      pygments
    ];
  };

  nativeCheckInputs = [
    aiosqlite
    fastapi
    inline-snapshot
    pytest-asyncio
    pytestCheckHook
    twilio
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "agents" ];

  disabledTestPaths = [
    # Require files from .github/scripts/ not shipped in the sdist
    "tests/test_change_detection.py"
    "tests/test_check_optional_truthiness.py"
    "tests/test_release_automation.py"
    "tests/test_release_provenance.py"
    "tests/test_run_serial_tests.py"
    "tests/test_update_rclone_pin.py"
    # Require integration_tests module which is not in the sdist
    "tests/test_released_api_contract.py"
    "tests/test_run_state_compatibility_corpus.py"
    # Missing dependencies
    "tests/extensions/sandbox/test_vercel_provider_contract.py"
    "tests/extensions/memory/test_sqlalchemy_session.py"
    "tests/extensions/memory/test_redis_session.py"
    "tests/docs/test_translate_docs.py"
    "tests/mcp/test_mcp_pagination_integration.py"
    "tests/test_run_examples_script.py"
    # Other issues (depends on .github/scripts/, )
    "examples/"
    "tests/sandbox/test_runtime.py"
    "tests/test_asyncio_stability_command.py"
    "tests/test_code_change_verification_runner.py"
    "tests/test_code_change_verification_policy.py"
    "tests/sandbox/integration_tests/test_runner_pause_resume.py"
    "tests/test_error_logging_redaction.py"
    "tests/test_integration_runner.py"
    "tests/test_output_tool.py"
    "tests/test_release_please.py"
    "tests/test_repository_workflow_interfaces.py"
    "tests/test_responses_tracing.py"
    "tests/test_usage.py"
  ];

  disabledTests = [
    # cache_write_tokens_details field absent
    "test_any_llm_chat_stream_populates_span_before_yielding_completed"
    "test_any_llm_chat_stream_preserves_trace_data_at_completed[ModelTracing"
    "test_external_clear_resets_stale_branch_before_default_reads[usage"
    "test_get_response_span_exports_usage"
    "test_preserves_usage_data"
    "test_stream_span_is_populated_before_yielding_completed"
    "test_stream_span_is_recorded_for_a_consumer_that_stops_at_the_terminal_event"
    # Realtime session tests fail in the sandbox
    "test_async_realtime_handoff_detaches_session_from_redacted_error_traceback"
    "test_synchronous_realtime_handoff_clears_redacted_error_traceback"
    "test_synchronous_realtime_handoff_preserves_diagnostic_traceback_locals"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
    export CI=0
  '';

  meta = {
    description = "Lightweight, powerful framework for multi-agent workflows";
    homepage = "https://github.com/openai/openai-agents-python";
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bryanhonof ];
  };
})
