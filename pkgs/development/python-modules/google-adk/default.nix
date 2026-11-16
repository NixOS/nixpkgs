{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  gitUpdater,

  # build-system
  flit-core,

  # dependencies
  aiosqlite,
  authlib,
  click,
  cryptography,
  fastapi,
  google-auth,
  google-genai,
  graphviz,
  httpx,
  jsonschema,
  opentelemetry-api,
  opentelemetry-sdk,
  packaging,
  pydantic,
  python-dotenv,
  python-multipart,
  pyyaml,
  requests,
  starlette,
  tenacity,
  typing-extensions,
  uvicorn,
  watchdog,
  websockets,

  # tests
  a2a-sdk,
  absl-py,
  anthropic,
  anyio,
  beautifulsoup4,
  e2b,
  fsspec,
  google-api-core,
  google-api-python-client,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  google-cloud-bigtable,
  google-cloud-firestore,
  google-cloud-pubsub,
  google-cloud-resource-manager,
  google-cloud-secret-manager,
  google-cloud-spanner,
  google-cloud-speech,
  google-cloud-storage,
  hypothesis,
  jinja2,
  litellm,
  lxml,
  mcp,
  openai,
  openpyxl,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation-grpc,
  opentelemetry-instrumentation-httpx,
  opentelemetry-resourcedetector-gcp,
  pandas,
  pyarrow,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  sqlalchemy,
  tabulate,
  xlrd,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-adk";
  version = "2.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "adk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dpwJ0oqjgbVYX6GmJ84WY1YKZcXxq3iOhquSsXWdHmU=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [ "websockets" ];

  dependencies = [
    aiosqlite
    authlib
    click
    cryptography
    fastapi
    google-auth
    google-genai
    graphviz
    httpx
    jsonschema
    opentelemetry-api
    opentelemetry-sdk
    packaging
    pydantic
    python-dotenv
    python-multipart
    pyyaml
    requests
    starlette
    tenacity
    typing-extensions
    uvicorn
    watchdog
    websockets
  ]
  ++ google-auth.optional-dependencies.pyopenssl;

  nativeCheckInputs = [
    a2a-sdk
    absl-py
    anthropic
    anyio
    beautifulsoup4
    e2b
    fsspec
    google-api-core
    google-api-python-client
    google-cloud-bigquery
    google-cloud-bigquery-storage
    google-cloud-bigtable
    google-cloud-firestore
    google-cloud-pubsub
    google-cloud-resource-manager
    google-cloud-secret-manager
    google-cloud-spanner
    google-cloud-speech
    google-cloud-storage
    hypothesis
    jinja2
    litellm
    lxml
    mcp
    openai
    openpyxl
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-grpc
    opentelemetry-instrumentation-httpx
    opentelemetry-resourcedetector-gcp
    pandas
    pyarrow
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    python-dateutil
    sqlalchemy
    tabulate
    xlrd
  ];

  # integration/ and remote/ need network access and credentials
  enabledTestPaths = [ "tests/unittests" ];

  disabledTestPaths = [
    # optional dependencies not packaged in nixpkgs:
    # google-cloud-aiplatform (vertexai), google-cloud-agentplatform,
    # google-antigravity, google-cloud-discoveryengine, daytona, opensandbox.
    "tests/unittests/agents/test_llm_agent_fields.py"
    "tests/unittests/code_executors/test_agent_engine_sandbox_code_executor.py"
    "tests/unittests/code_executors/test_vertex_ai_code_executor.py"
    "tests/unittests/dependencies/test_vertexai.py"
    "tests/unittests/evaluation"
    "tests/unittests/examples/test_vertex_ai_example_store.py"
    "tests/unittests/integrations/agent_identity"
    "tests/unittests/integrations/agent_registry"
    "tests/unittests/integrations/bigquery/test_bigquery_client.py"
    "tests/unittests/integrations/bigquery/test_bigquery_search_tool.py"
    "tests/unittests/integrations/daytona"
    "tests/unittests/integrations/eventarc"
    "tests/unittests/integrations/model_armor"
    "tests/unittests/integrations/opensandbox"
    "tests/unittests/integrations/vmaas/test_sandbox_computer.py"
    "tests/unittests/labs/antigravity"
    "tests/unittests/memory/test_vertex_ai_memory_bank_service.py"
    "tests/unittests/memory/test_vertex_ai_rag_memory_service.py"
    "tests/unittests/optimization/local_eval_sampler_test.py"
    "tests/unittests/sessions/test_vertex_ai_session_service.py"
    "tests/unittests/telemetry/test_functional.py"
    "tests/unittests/telemetry/test_genai_instrumentor_bypass.py"
    "tests/unittests/telemetry/test_google_cloud.py"
    "tests/unittests/telemetry/test_node_functional.py"
    "tests/unittests/telemetry/test_semconv_conformance.py"
    "tests/unittests/telemetry/test_smoke.py"
    "tests/unittests/telemetry/test_web_ui_functional.py"
    "tests/unittests/tools/retrieval/test_files_retrieval.py"
    "tests/unittests/tools/retrieval/test_vertex_ai_rag_retrieval.py"
    "tests/unittests/tools/test_discovery_engine_search_tool.py"
    "tests/unittests/tools/test_google_tool.py"
    "tests/unittests/tools/test_vertex_ai_load_profiles_tool.py"
    # sample agents use unpackaged integrations
    "tests/unittests/test_samples.py"
    # integrations whose heavy dependencies (langchain-core, docker,
    # kubernetes) are left out of nativeCheckInputs
    "tests/unittests/code_executors/test_container_code_executor.py"
    "tests/unittests/code_executors/test_gke_code_executor.py"
    "tests/unittests/integrations/langchain"
    # check upstream's exact dependency set and pinned release bounds
    "tests/unittests/test_import_loading.py"
    "tests/unittests/test_release_dependencies.py"
  ];

  disabledTests = [
    # google.adk.evaluation needs vertexai (google-cloud-aiplatform)
    "test_cli_eval"
    "test_cli_generate_eval_cases"
    "test_cli_optimize"
    "test_list_metrics_info"
    # need google-cloud-agentplatform / iamconnectorcredentials / discoveryengine
    "reasoning_engine"
    "test_finalize_agent_identity_credentials"
    "test_to_agent_engine_respects_multiple_ignore_files"
    "test_vertex_ai_session_service_raises_not_implemented_for_get_user_state"
    "test_use_extra_generate_content_attributes"
    "test_detect_error_discovery_engine_search_tool"
    # needs sqlalchemy-spanner
    "test_load_dialect_impl_spanner"
  ];

  pythonImportsCheck = [ "google.adk" ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Google Agent Development Kit (ADK)";
    longDescription = ''
      An open-source, code-first Python toolkit for building, evaluating,
      and deploying sophisticated AI agents with flexibility and control.
    '';
    homepage = "https://github.com/google/adk-python";
    changelog = "https://github.com/google/adk-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dshatz ];
  };
})
