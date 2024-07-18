{
  lib,
  buildPythonPackage,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  accelerate,
  bentoml,
  bitsandbytes,
  build,
  click,
  ctranslate2,
  datasets,
  docker,
  einops,
  ghapi,
  huggingface-hub,
  hypothesis,
  ipython,
  jupyter,
  jupytext,
  nbformat,
  notebook,
  openai,
  openllm-client,
  openllm-core,
  optimum,
  peft,
  pytest-mock,
  pytest-randomly,
  pytest-rerunfailures,
  pytest-xdist,
  safetensors,
  scipy,
  sentencepiece,
  soundfile,
  syrupy,
  tabulate,
  tiktoken,
  transformers,
  triton,
  xformers,
}:

buildPythonPackage rec {
  inherit (openllm-core) src version;
  pname = "openllm";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${src.name}/openllm-python";


  pythonRemoveDeps = [
    # remove cuda-python as it has an unfree license
    "cuda-python"
  ];

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies =
    [
      accelerate
      bentoml
      bitsandbytes
      build
      click
      einops
      ghapi
      openllm-client
      openllm-core
      optimum
      safetensors
      scipy
      sentencepiece
      transformers
    ]
    ++ bentoml.optional-dependencies.io
    ++ tabulate.optional-dependencies.widechars
    ++ transformers.optional-dependencies.tokenizers
    ++ transformers.optional-dependencies.torch;

  optional-dependencies = {
    agents = [
      # diffusers
      soundfile
      transformers
    ] ++ transformers.optional-dependencies.agents;
    awq = [
      # autoawq
    ];
    baichuan = [
      # cpm-kernels
    ];
    chatglm = [
      # cpm-kernels
    ];
    ctranslate = [ ctranslate2 ];
    falcon = [ xformers ];
    fine-tune = [
      datasets
      huggingface-hub
      peft
      # trl
    ];
    ggml = [
      # ctransformers
    ];
    gptq = [
      # auto-gptq
    ]; # ++ autogptq.optional-dependencies.triton;
    grpc = [ bentoml ] ++ bentoml.optional-dependencies.grpc;
    mpt = [ triton ];
    openai = [
      openai
      tiktoken
    ] ++ openai.optional-dependencies.datalib;
    playground = [
      ipython
      jupyter
      jupytext
      nbformat
      notebook
    ];
    starcoder = [ bitsandbytes ];
    vllm = [
      # vllm
    ];
    full =
      with optional-dependencies;
      (
        agents
        ++ awq
        ++ baichuan
        ++ chatglm
        ++ ctranslate
        ++ falcon
        ++ fine-tune
        ++ ggml
        ++ gptq
        ++ mpt
        # disambiguate between derivation input and passthru field
        ++ optional-dependencies.openai
        ++ playground
        ++ starcoder
        ++ vllm
      );
    all = optional-dependencies.full;
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
    # disable hypothesis' deadline
    export CI=1
  '';

  disabledTestPaths = [
    # require network access
    "tests/models"
  ];

  disabledTests = [
    # incompatible with recent TypedDict
    # https://github.com/bentoml/OpenLLM/blob/f3fd32d596253ae34c68e2e9655f19f40e05f666/openllm-python/tests/configuration_test.py#L18-L21
    "test_missing_default"
  ];

  pythonImportsCheck = [ "openllm" ];

  meta = with lib; {
    description = "Operating LLMs in production";
    homepage = "https://github.com/bentoml/OpenLLM/tree/main/openllm-python";
    changelog = "https://github.com/bentoml/OpenLLM/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      natsukium
    ];
  };
}
