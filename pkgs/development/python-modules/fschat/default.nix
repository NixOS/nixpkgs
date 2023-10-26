{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, aiohttp
, fastapi
, httpx
, markdown2
, nh3
, numpy
, prompt-toolkit
, pydantic
, requests
, rich
, shortuuid
, tiktoken
, uvicorn
, anthropic
, openai
, ray
, wandb
, einops
, gradio
, accelerate
, peft
, sentencepiece
, torch
, transformers
, protobuf
}:
let
  version = "0.2.30";
in
buildPythonPackage {
  pname = "fschat";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lm-sys";
    repo = "FastChat";
    rev = "refs/tags/v${version}";
    hash = "sha256-SkrdRpmbxnt/Xn8TTmozxhr3fPeAFPP7X0cM9vJC9Sc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    fastapi
    httpx
    markdown2
    nh3
    numpy
    prompt-toolkit
    pydantic
    requests
    rich
    shortuuid
    tiktoken
    uvicorn
  # ] ++ markdown2.optional-dependencies.all;
  ];

  passthru.optional-dependencies = {
    llm_judge = [
      anthropic
      openai
      ray
    ];
    train = [
      # flash-attn
      wandb
      einops
    ];
    webui = [
      gradio
    ];
    model_worker = [
      accelerate
      peft
      sentencepiece
      torch
      transformers
      protobuf
    ];
  };

  pythonImportsCheck = [ "fastchat" ];

  # tests require networking
  doCheck = false;

  meta = with lib; {
    description = "An open platform for training, serving, and evaluating large language models. Release repo for Vicuna and Chatbot Arena";
    homepage = "https://github.com/lm-sys/FastChat";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
