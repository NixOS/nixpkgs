{ lib
, python3
, fetchFromGitHub
, poetry-core
, fastapi
, injector
, llama-index-core
, llama-index-readers-file
, python-multipart
, pyyaml
, transformers
, uvicorn
, watchdog
}:

python3.pkgs.buildPythonPackage rec {
  pname = "private-gpt";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zylon-ai";
    repo = "private-gpt";
    rev = "v${version}";
    hash = "sha256-E9V7m5bxq+8e2tPxPdcDQOVKgy8R2LDhJO9QNlbI6og=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    fastapi
    injector
    llama-index-core
    llama-index-readers-file
    python-multipart
    pyyaml
    transformers
    uvicorn
    watchdog
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    embeddings-huggingface = [
      llama-index-embeddings-huggingface
    ];
    embeddings-ollama = [
      llama-index-embeddings-ollama
    ];
    embeddings-openai = [
      llama-index-embeddings-openai
    ];
    embeddings-sagemaker = [
      boto3
    ];
    llms-llama-cpp = [
      llama-index-llms-llama-cpp
    ];
    llms-ollama = [
      llama-index-llms-ollama
    ];
    llms-openai = [
      llama-index-llms-openai
    ];
    llms-openai-like = [
      llama-index-llms-openai-like
    ];
    llms-sagemaker = [
      boto3
    ];
    ui = [
      gradio
    ];
    vector-stores-chroma = [
      llama-index-vector-stores-chroma
    ];
    vector-stores-postgres = [
      llama-index-vector-stores-postgres
    ];
    vector-stores-qdrant = [
      llama-index-vector-stores-qdrant
    ];
  };

  pythonImportsCheck = [ "private_gpt" ];

  meta = with lib; {
    description = "Interact with your documents using the power of GPT, 100% privately, no data leaks";
    homepage = "https://github.com/zylon-ai/private-gpt";
    changelog = "https://github.com/zylon-ai/private-gpt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "private-gpt";
  };
}
