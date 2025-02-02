{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  poetry-core,
  fastapi,
  injector,
  llama-index-core,
  llama-index-readers-file,
  huggingface-hub,
  python-multipart,
  pyyaml,
  transformers,
  uvicorn,
  watchdog,
  gradio,
  fetchurl,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "private-gpt";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zylon-ai";
    repo = "private-gpt";
    rev = "v${version}";
    hash = "sha256-bjydzJhOJjmbflcJbuMyNsmby7HtNPFW3MY2Tw12cHw=";
  };

  patches = [
    # Fix a vulnerability, to be removed in the next bump version
    # See https://github.com/zylon-ai/private-gpt/pull/1890
    (fetchpatch {
      url = "https://github.com/zylon-ai/private-gpt/commit/86368c61760c9cee5d977131d23ad2a3e063cbe9.patch";
      hash = "sha256-4ysRUuNaHW4bmNzg4fn++89b430LP6AzYDoX2HplVH0=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    fastapi
    injector
    llama-index-core
    llama-index-readers-file
    python-multipart
    pyyaml
    transformers
    uvicorn
    watchdog
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # This is needed for running the tests and the service in offline mode,
  # See related issue at https://github.com/zylon-ai/private-gpt/issues/1870
  passthru.cl100k_base.tiktoken = fetchurl {
    url = "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
    hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
  };

  passthru.optional-dependencies = with python.pkgs; {
    embeddings-huggingface = [
      huggingface-hub
      llama-index-embeddings-huggingface
    ];
    embeddings-ollama = [ llama-index-embeddings-ollama ];
    embeddings-openai = [ llama-index-embeddings-openai ];
    embeddings-sagemaker = [ boto3 ];
    llms-ollama = [ llama-index-llms-ollama ];
    llms-openai = [ llama-index-llms-openai ];
    llms-openai-like = [ llama-index-llms-openai-like ];
    llms-sagemaker = [ boto3 ];
    ui = [ gradio ];
    vector-stores-chroma = [ llama-index-vector-stores-chroma ];
    vector-stores-postgres = [ llama-index-vector-stores-postgres ];
    vector-stores-qdrant = [ llama-index-vector-stores-qdrant ];
  };

  postInstall = ''
    cp settings*.yaml $out/${python.sitePackages}/private_gpt/
  '';

  pythonImportsCheck = [ "private_gpt" ];

  meta = {
    changelog = "https://github.com/zylon-ai/private-gpt/blob/${src.rev}/CHANGELOG.md";
    description = "Interact with your documents using the power of GPT, 100% privately, no data leaks";
    homepage = "https://github.com/zylon-ai/private-gpt";
    license = lib.licenses.asl20;
    mainProgram = "private-gpt";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
