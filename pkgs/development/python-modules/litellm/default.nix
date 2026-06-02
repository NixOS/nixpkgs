{
  lib,
  a2a-sdk,
  aiohttp,
  anthropic,
  apscheduler,
  azure-identity,
  azure-keyvault-secrets,
  azure-storage-blob,
  azure-storage-file-datalake,
  backoff,
  boto3,
  buildPythonPackage,
  click,
  cryptography,
  fastapi,
  fastapi-sso,
  fastuuid,
  fetchFromGitHub,
  google-cloud-iam,
  google-cloud-kms,
  google-genai,
  grpcio,
  gunicorn,
  httpx,
  importlib-metadata,
  jinja2,
  jsonschema,
  langfuse,
  mcp,
  openai,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  orjson,
  polars,
  prisma,
  prometheus-client,
  pydantic,
  pyjwt,
  pynacl,
  pypdf,
  python-dotenv,
  python-multipart,
  pyyaml,
  requests,
  resend,
  restrictedpython,
  rich,
  rq,
  sentry-sdk,
  soundfile,
  tiktoken,
  tokenizers,
  uv-build,
  uvicorn,
  uvloop,
  websockets,
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "litellm";
  version = "1.83.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}-stable";
    hash = "sha256-SZow0qof9DRlohWjT3J/NHtmhe96OLLcdHt55RQ7Zmw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build==0.10.7" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    click
    fastuuid
    httpx
    importlib-metadata
    jinja2
    jsonschema
    openai
    pydantic
    python-dotenv
    requests
    tiktoken
    tokenizers
  ];

  optional-dependencies = {
    proxy = [
      apscheduler
      azure-identity
      azure-storage-blob
      backoff
      boto3
      cryptography
      fastapi
      fastapi-sso
      gunicorn
      # FIXME package litellm-enterprise
      # FIXME package litellm-proxy-extras
      mcp
      orjson
      polars
      pyjwt
      pynacl
      python-multipart
      pyyaml
      restrictedpython
      rich
      rq
      soundfile
      uvloop
      uvicorn
      websockets
    ];

    extra_proxy = [
      a2a-sdk
      azure-identity
      azure-keyvault-secrets
      google-cloud-iam
      google-cloud-kms
      prisma
      # FIXME package redisvl
      resend
    ];

    proxy-runtime = [
      anthropic
      # FIXME package azure-ai-contentsafety
      azure-storage-file-datalake
      # FIXME package ddtrace
      # FIXME package detect-secrets
      # FIXME package google-cloud-aiplatform
      google-genai
      grpcio
      langfuse
      # FIXME package mangum
      opentelemetry-api
      opentelemetry-exporter-otlp
      opentelemetry-sdk
      # FIXME package llm-sandbox
      prometheus-client
      pypdf
      sentry-sdk
    ];
  };

  pythonImportsCheck = [ "litellm" ];

  pythonRelaxDeps = [
    "aiohttp"
    "click"
    "importlib-metadata"
    "jsonschema"
    "openai"
    "python-dotenv"
  ];

  # access network
  doCheck = false;

  passthru = {
    tests = { inherit (nixosTests) litellm; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9]+\\.[0-9]+\\.[0-9]+)-stable"
      ];
    };
  };

  meta = {
    description = "Use any LLM as a drop in replacement for gpt-3.5-turbo. Use Azure, OpenAI, Cohere, Anthropic, Ollama, VLLM, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
    mainProgram = "litellm";
    homepage = "https://github.com/BerriAI/litellm";
    changelog = "https://github.com/BerriAI/litellm/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
