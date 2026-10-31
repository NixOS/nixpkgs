{
  lib,
  a2a-sdk,
  aiohttp,
  anthropic,
  apscheduler,
  azure-ai-contentsafety,
  azure-identity,
  azure-keyvault-secrets,
  azure-storage-blob,
  azure-storage-file-datalake,
  backoff,
  boto3,
  buildPythonPackage,
  certifi,
  click,
  cryptography,
  detect-secrets,
  expression,
  fastapi,
  fastapi-sso,
  fastuuid,
  fetchFromGitHub,
  fetchpatch2,
  filelock,
  google-cloud-iam,
  google-cloud-kms,
  google-cloud-speech,
  google-genai,
  grpcio,
  gunicorn,
  httpx,
  httpx2,
  huggingface-hub,
  importlib-metadata,
  inquirerpy,
  jinja2,
  jsonschema,
  langfuse,
  litellm-proxy-extras,
  llm-sandbox,
  mcp,
  openai,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  orjson,
  packaging,
  polars,
  prisma,
  prometheus-client,
  psycopg,
  pydantic,
  pydantic-settings,
  pyjwt,
  pynacl,
  pypdf,
  python-dotenv,
  python-multipart,
  pyyaml,
  redisvl,
  resend,
  restrictedpython,
  rich,
  rq,
  rustPlatform,
  sentry-sdk,
  soundfile,
  tiktoken,
  tokenizers,
  tomlkit,
  typing-extensions,
  uvicorn,
  uvloop,
  websockets,
  nixosTests,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "litellm";
  version = "1.106.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0fgMRYOqCQJuoH7UHyuTmB89Kpu3wTb5Rv5xW+kvcPA=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoRoot = "litellm-rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-Qf6LV9p6Acy1wewcqrSvJf7CMyus94CNqWtq2CMALso=";
  };

  patches = [
    # fix import race when offline
    ./model-cost-map-retry-wait-for-import.patch
    (fetchpatch2 {
      # fix: support Python 3.15
      url = "https://github.com/BerriAI/litellm/pull/48359.patch?full_index=1";
      hash = "sha256-VTj6ak0UfJZXw+mLVaP/i0xaY/u3WunY/9dO/sXJmW0=";
      includes = [ "pyproject.toml" ];
    })
    (fetchpatch2 {
      # build: allow filelock 4.x and sync package metadata
      url = "https://github.com/BerriAI/litellm/pull/49137.patch?full_index=1";
      hash = "sha256-zgljfII+N22BsZ2KI9vz+23yAxYEA3bZbvUvF7gJBHE=";
      includes = [ "pyproject.toml" ];
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "maturin==1.15.0" "maturin>=1.0,<2.0"
  '';

  dependencies = [
    aiohttp
    boto3
    certifi
    click
    fastuuid
    filelock
    httpx
    huggingface-hub
    importlib-metadata
    jinja2
    jsonschema
    openai
    packaging
    pydantic
    pydantic-settings
    python-dotenv
    pyyaml
    tiktoken
    tokenizers
    typing-extensions
  ]
  ++ httpx.optional-dependencies.http2;

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
      httpx2
      inquirerpy
      # FIXME package litellm-enterprise
      litellm-proxy-extras
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
      tomlkit
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
      psycopg
      redisvl
      resend
    ];

    proxy-runtime = [
      anthropic
      azure-ai-contentsafety
      azure-storage-file-datalake
      # FIXME package ddtrace
      detect-secrets
      # FIXME package google-cloud-aiplatform
      google-cloud-speech
      google-genai
      grpcio
      langfuse
      # FIXME package mangum
      opentelemetry-api
      opentelemetry-exporter-otlp
      opentelemetry-sdk
      llm-sandbox
      prometheus-client
      pypdf
      sentry-sdk
    ]
    # litellm's skills executor uses the default docker backend
    ++ llm-sandbox.optional-dependencies.docker;
  };

  pythonImportsCheck = [ "litellm" ];

  pythonRelaxDeps = [
    "aiohttp"
    "boto3"
    "certifi"
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
        "v([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
  };

  meta = {
    description = "Call LLM APIs in OpenAI (or native) format with cost tracking, guardrails, load balancing, and logging";
    mainProgram = "litellm";
    homepage = "https://github.com/BerriAI/litellm";
    changelog = "https://github.com/BerriAI/litellm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      anish
    ];
  };
})
