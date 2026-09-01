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
  expression,
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
  inquirerpy,
  jinja2,
  jsonschema,
  langfuse,
  maturin,
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
  pydantic-settings,
  pyjwt,
  pynacl,
  pypdf,
  python-dotenv,
  python-multipart,
  pyyaml,
  resend,
  restrictedpython,
  rich,
  rq,
  rustPlatform,
  sentry-sdk,
  soundfile,
  tiktoken,
  tokenizers,
  uvicorn,
  uvloop,
  websockets,
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "litellm";
  version = "1.98.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}";
    hash = "sha256-eMquDSSlBo//huXXiys/F36O18VDjv7U1OUe7DrKhus=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoRoot = "litellm-rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-iwgIclG8BGeHDNtm686w2Rxe+9ddvBrz1sMfOBeuKK0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "maturin==1.9.4" "maturin==${maturin.version}"
  '';

  dependencies = [
    aiohttp
    boto3
    click
    fastuuid
    httpx
    importlib-metadata
    jinja2
    jsonschema
    openai
    pydantic
    pydantic-settings
    python-dotenv
    tiktoken
    tokenizers
  ];

  optional-dependencies = {
    proxy = [
      apscheduler
      azure-identity
      azure-storage-blob
      backoff
      cryptography
      expression
      fastapi
      fastapi-sso
      gunicorn
      inquirerpy
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
    "boto3"
    "click"
    "importlib-metadata"
    "jsonschema"
    "openai"
    "pydantic"
    "python-dotenv"
  ];

  # access network
  doCheck = false;

  passthru = {
    tests = { inherit (nixosTests) litellm; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9]+\\.[0-9]+\\.[0-9]+)"
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
