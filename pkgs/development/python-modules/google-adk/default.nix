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

  # optional-dependencies
  gepa,
  google-cloud-aiplatform,
  google-cloud-texttospeech,
  jinja2,
  nltk,
  openpyxl,
  pandas,
  rouge-score,
  tabulate,
  xlrd,

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
  litellm,
  lxml,
  mcp,
  openai,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation-grpc,
  opentelemetry-instrumentation-httpx,
  opentelemetry-resourcedetector-gcp,
  pyarrow,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  sqlalchemy,
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

  optional-dependencies = {
    eval = [
      gepa
      google-cloud-aiplatform
      google-cloud-texttospeech
      jinja2
      nltk
      openpyxl
      pandas
      rouge-score
      tabulate
      xlrd
    ]
    ++ google-cloud-aiplatform.optional-dependencies.evaluation;
  };

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
    litellm
    lxml
    mcp
    openai
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-grpc
    opentelemetry-instrumentation-httpx
    opentelemetry-resourcedetector-gcp
    pyarrow
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    python-dateutil
    sqlalchemy
  ]
  ++ finalAttrs.passthru.optional-dependencies.eval;

  # integration/ and remote/ need network access and credentials
  enabledTestPaths = [ "tests/unittests" ];

  disabledTestPaths = [
    # optional dependencies not packaged in nixpkgs
    # google-antigravity
    "tests/unittests/labs/antigravity"
    # google-cloud-agentidentitycredentials
    "tests/unittests/integrations/agent_identity"
    "tests/unittests/integrations/agent_registry"
    # google-cloud-dataplex
    "tests/unittests/integrations/bigquery/test_bigquery_client.py"
    "tests/unittests/integrations/bigquery/test_bigquery_search_tool.py"
    # google-cloud-discoveryengine
    "tests/unittests/agents/test_llm_agent_fields.py"
    "tests/unittests/tools/test_discovery_engine_search_tool.py"
    # google-cloud-eventarc-publishing
    "tests/unittests/integrations/eventarc"
    # google-cloud-modelarmor
    "tests/unittests/integrations/model_armor"
    # daytona, opensandbox
    "tests/unittests/integrations/daytona"
    "tests/unittests/integrations/opensandbox"
    # opentelemetry-instrumentation-google-genai
    "tests/unittests/telemetry/test_functional.py"
    "tests/unittests/telemetry/test_genai_instrumentor_bypass.py"
    "tests/unittests/telemetry/test_node_functional.py"
    "tests/unittests/telemetry/test_semconv_conformance.py"
    "tests/unittests/telemetry/test_smoke.py"
    "tests/unittests/telemetry/test_web_ui_functional.py"
    # llama-index (heavy, left out of nativeCheckInputs)
    "tests/unittests/tools/retrieval/test_files_retrieval.py"
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
    # google-cloud-iamconnectorcredentials
    "test_finalize_agent_identity_credentials"
    # google-cloud-discoveryengine
    "test_detect_error_discovery_engine_search_tool"
    # opentelemetry-instrumentation-google-genai
    "test_use_extra_generate_content_attributes"
    # sqlalchemy-spanner
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
