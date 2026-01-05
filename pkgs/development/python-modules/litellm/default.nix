{
  lib,
  aiohttp,
  apscheduler,
  azure-identity,
  azure-keyvault-secrets,
  azure-storage-blob,
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
  gunicorn,
  httpx,
  importlib-metadata,
  jinja2,
  jsonschema,
  mcp,
  openai,
  orjson,
  poetry-core,
  polars,
  prisma,
  pydantic,
  pyjwt,
  pynacl,
  python,
  python-dotenv,
  python-multipart,
  pyyaml,
  requests,
  resend,
  rich,
  rq,
  soundfile,
  tiktoken,
  tokenizers,
  uvloop,
  uvicorn,
  websockets,
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "litellm";
  version = "1.80.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}-stable.1";
    hash = "sha256-W1tckXXQ9PlqTW5S4ml0X5rcPXSCioubDaSkQxHQrMY=";
  };

  build-system = [ poetry-core ];

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
      rich
      rq
      soundfile
      uvloop
      uvicorn
      websockets
    ];

    extra_proxy = [
      azure-identity
      azure-keyvault-secrets
      google-cloud-iam
      google-cloud-kms
      prisma
      # FIXME package redisvl
      resend
    ];
  };

  pythonImportsCheck = [
    "litellm"
    "litellm_enterprise"
  ];

  # Relax dependency check on openai, may not be needed in the future
  pythonRelaxDeps = [ "openai" ];

  # access network
  doCheck = false;

  postFixup = ''
    # Symlink litellm_enterprise to make it discoverable
    pushd $out/lib/python${python.pythonVersion}/site-packages
    ln -s enterprise/litellm_enterprise litellm_enterprise
    popd
  '';

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
