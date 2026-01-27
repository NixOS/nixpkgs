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
  fetchPypi,
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
  version = "1.80.16";
  pyproject = true;

  # litellm does not have a stable tag for each release, use the PyPI source instead
  src = fetchPypi {
    pname = "litellm";
    inherit version;
    hash = "sha256-+WIzZJ+Zqwl/fYo/+YmGgCB7nup9LiP0OAdKPbz1DMo=";
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

  # access network
  doCheck = false;

  # Copy litellm_enterprise to make it discoverable
  postFixup = ''
    cp -r ./enterprise/litellm_enterprise $out/lib/python${python.pythonVersion}/site-packages/litellm_enterprise
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
    description = "Call 100+ LLMs in OpenAI format";
    longDescription = ''
      Python SDK, Proxy Server (AI Gateway) to call 100+ LLM APIs in
      OpenAI (or native) format, with cost tracking, guardrails,
      loadbalancing and logging. [Bedrock, Azure, OpenAI, VertexAI,
      Cohere, Anthropic, Sagemaker, HuggingFace, VLLM, NVIDIA NIM]
    '';
    mainProgram = "litellm";
    homepage = "https://github.com/BerriAI/litellm";
    changelog = "https://docs.litellm.ai/release_notes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      yzx9
    ];
  };
}
