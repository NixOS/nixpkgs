{
  lib,
  aiohttp,
  apscheduler,
  azure-identity,
  azure-keyvault-secrets,
  backoff,
  boto3,
  buildPythonPackage,
  click,
  cryptography,
  email-validator,
  fastapi,
  fastapi-sso,
  fetchFromGitHub,
  google-cloud-kms,
  gunicorn,
  importlib-metadata,
  jinja2,
  jsonschema,
  mcp,
  openai,
  orjson,
  poetry-core,
  prisma,
  pydantic,
  pyjwt,
  pynacl,
  python,
  python-dotenv,
  python-multipart,
  pythonOlder,
  pyyaml,
  requests,
  resend,
  rich,
  rq,
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
  version = "1.75.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}-stable";
    hash = "sha256-VedQ0cNOf9vUFF7wjT7WOsCfTesIvzhudDfGnBTXO3E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    email-validator
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
      backoff
      boto3
      cryptography
      fastapi
      fastapi-sso
      gunicorn
      mcp
      orjson
      pyjwt
      pynacl
      python-multipart
      pyyaml
      rich
      rq
      uvloop
      uvicorn
      websockets
    ];

    extra_proxy = [
      azure-identity
      azure-keyvault-secrets
      google-cloud-kms
      prisma
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
