{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  runCommand,
  # Core runtime dependencies (propagated); floors relaxed via pythonRelaxDeps.
  aiohttp,
  alembic,
  anthropic,
  asyncpg,
  authlib,
  boto3,
  claude-agent-sdk,
  cohere,
  croniter,
  cryptography,
  dateparser,
  fastapi,
  fastmcp,
  filelock,
  google-auth,
  google-genai,
  greenlet,
  httpx,
  langchain-core,
  langchain-text-splitters,
  langsmith,
  litellm,
  markitdown,
  obstore,
  openai,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-exporter-prometheus,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  orjson,
  pgvector,
  pillow,
  protobuf,
  psycopg2-binary,
  pyasn1,
  pydantic,
  pygments,
  pyjwt,
  python-dateutil,
  python-dotenv,
  python-multipart,
  rich,
  sqlalchemy,
  tiktoken,
  tornado,
  typer,
  urllib3,
  uvicorn,
  uvloop,
  wsproto,
}:

buildPythonPackage (finalAttrs: {
  pname = "hindsight-api-slim";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "hindsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w6diZVKzRaRxrr0G3EOqA2nAl4r5VkQfepUZz8b7YJ8=";
  };
  sourceRoot = "${finalAttrs.src.name}/hindsight-api-slim";

  build-system = [ hatchling ];

  # Floors relaxed to whatever nixpkgs ships; nixpkgs is at or above every
  # CVE-fixing floor upstream pins (e.g. cryptography>=48.0.1 for
  # GHSA-537c-gmf6-5ccf). Re-evaluate on revbump.
  pythonRelaxDeps = [
    "aiohttp"
    "alembic"
    "anthropic"
    "asyncpg"
    "authlib"
    "boto3"
    "claude-agent-sdk"
    "cohere"
    "croniter"
    "cryptography"
    "dateparser"
    "fastapi"
    "fastmcp"
    "filelock"
    "google-auth"
    "google-genai"
    "greenlet"
    "httpx"
    "langchain-core"
    "langchain-text-splitters"
    "langsmith"
    "litellm"
    "markitdown"
    "obstore"
    "openai"
    "opentelemetry-api"
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-instrumentation-fastapi"
    "opentelemetry-sdk"
    "opentelemetry-semantic-conventions"
    "orjson"
    "pgvector"
    "pillow"
    "protobuf"
    "psycopg2-binary"
    "pyasn1"
    "pydantic"
    "pygments"
    "pyjwt"
    "python-dateutil"
    "python-dotenv"
    "python-multipart"
    "rich"
    "sqlalchemy"
    "tiktoken"
    "tornado"
    "typer"
    "urllib3"
    "uvicorn"
    "uvloop"
    "wsproto"
  ];

  dependencies = [
    aiohttp
    alembic
    anthropic
    asyncpg
    authlib
    boto3
    claude-agent-sdk
    cohere
    croniter
    cryptography
    dateparser
    fastapi
    fastmcp
    filelock
    google-auth
    google-genai
    greenlet
    httpx
    langchain-core
    langchain-text-splitters
    langsmith
    litellm
    markitdown
    obstore
    openai
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-exporter-prometheus
    opentelemetry-instrumentation-fastapi
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    orjson
    pgvector
    pillow
    protobuf
    psycopg2-binary
    pyasn1
    pydantic
    pygments
    pyjwt
    python-dateutil
    python-dotenv
    python-multipart
    rich
    sqlalchemy
    tiktoken
    tornado
    typer
    urllib3
    uvicorn
    uvloop
    wsproto
  ];

  # Upstream [all] extras omitted: local-ml/local-onnx need transformers>=5.5
  # (unsatisfiable in nixpkgs), local-llm needs llama-cpp-python, embedded-db
  # needs pg0-embedded — none packaged. Add to optional-dependencies once deps resolve.

  # Upstream tests need a live PostgreSQL + LLM credentials; closure is
  # covered by passthru.tests.
  doCheck = false;

  passthru.tests = {
    import-test = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
      pythonImportsCheck = [ "hindsight_api" ];
    };
    cli-help =
      runCommand "${finalAttrs.pname}-cli-help-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          hindsight-api --help
          touch $out
        '';
  };

  meta = {
    description = "Semantic agent memory API server with retain, recall and reflect operations";
    homepage = "https://github.com/vectorize-io/hindsight";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
    # mainProgram omitted: slim ships four console scripts
  };
})
