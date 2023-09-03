{ lib
, buildPythonPackage
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, accelerate
, bentoml
, bitsandbytes
, click
, datasets
, docker
, einops
, fairscale
, flax
, hypothesis
, ipython
, jax
, jaxlib
, jupyter
, jupytext
, keras
, nbformat
, notebook
, openai
, openllm-client
, openllm-core
, optimum
, peft
, pytest-mock
, pytest-randomly
, pytest-rerunfailures
, pytest-xdist
, ray
, safetensors
, sentencepiece
, soundfile
, syrupy
, tabulate
, tensorflow
, tiktoken
, transformers
, openai-triton
, xformers
}:

buildPythonPackage rec {
  inherit (openllm-core) src version;
  pname = "openllm";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  sourceRoot = "source/openllm-python";

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    # remove cuda-python as it has an unfree license
    "cuda-python"
  ];

  propagatedBuildInputs = [
    bentoml
    bitsandbytes
    click
    openllm-client
    optimum
    safetensors
    tabulate
    transformers
  ] ++ bentoml.optional-dependencies.io
  ++ tabulate.optional-dependencies.widechars
  # ++ transformers.optional-dependencies.accelerate
  ++ transformers.optional-dependencies.tokenizers
  ++ transformers.optional-dependencies.torch;

  passthru.optional-dependencies = {
    agents = [
      # diffusers
      soundfile
      transformers
    ] ++ transformers.optional-dependencies.agents;
    baichuan = [
      # cpm-kernels
      sentencepiece
    ];
    chatglm = [
      # cpm-kernels
      sentencepiece
    ];
    falcon = [
      einops
      xformers
    ];
    fine-tune = [
      accelerate
      bitsandbytes
      datasets
      peft
      # trl
    ];
    flan-t5 = [
      flax
      jax
      jaxlib
      keras
      tensorflow
    ];
    ggml = [
      # ctransformers
    ];
    gptq = [
      # auto-gptq
    ]; # ++ autogptq.optional-dependencies.triton;
    grpc = [
    openllm-client
    ] ++ openllm-client.optional-dependencies.grpc;
    llama = [
      fairscale
      sentencepiece
    ];
    mpt = [
      einops
      openai-triton
    ];
    openai = [
      openai
      tiktoken
    ];
    opt = [
      flax
      jax
      jaxlib
      keras
      tensorflow
    ];
    playground = [
      ipython
      jupyter
      jupytext
      nbformat
      notebook
    ];
    starcoder = [
      bitsandbytes
    ];
    vllm = [
      ray
      # vllm
    ];
    all = with passthru.optional-dependencies; (
      agents ++ baichuan ++ chatglm ++ falcon ++ fine-tune ++ flan-t5 ++ ggml ++ gptq ++ llama ++ mpt ++ openai ++ opt ++ playground ++ starcoder ++ vllm
    );
  };

  nativeCheckInputs = [
    docker
    hypothesis
    pytest-mock
    pytest-randomly
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  preCheck = ''
    export HOME=$TMPDIR
    # skip GPUs test on CI
    export GITHUB_ACTIONS=1
  '';

  disabledTests = [
    # these tests access to huggingface.co
    "test_opt_125m"
    "test_opt_125m"
    "test_flan_t5"
    "test_flan_t5"
  ];

  pythonImportsCheck = [ "openllm" ];

  meta = with lib; {
    description = "Operating LLMs in production";
    homepage = "https://github.com/bentoml/OpenLLM/tree/main/openllm-python";
    changelog = "https://github.com/bentoml/OpenLLM/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada natsukium ];
  };
}
