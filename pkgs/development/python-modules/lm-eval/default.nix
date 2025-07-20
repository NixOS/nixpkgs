{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  accelerate,
  aiohttp,
  antlr4-python3-runtime,
  causal-conv1d,
  datasets,
  dill,
  evaluate,
  hf-transfer,
  immutabledict,
  jsonlines,
  langdetect,
  mamba-ssm,
  more-itertools,
  nltk,
  numexpr,
  numpy,
  optimum,
  pandas,
  peft,
  pybind11,
  pytablewriter,
  pytestCheckHook,
  requests,
  rouge-score,
  sacrebleu,
  scikit-learn,
  sentencepiece,
  sqlitedict,
  sympy,
  tenacity,
  tiktoken,
  torch,
  tqdm,
  tqdm-multiprocess,
  transformers,
  vllm,
  wandb,
  word2number,
  zstandard,
}:

buildPythonPackage rec {
  pname = "lm-eval";
  version = "0.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EleutherAI";
    repo = "lm-evaluation-harness";
    tag = "v${version}";
    hash = "sha256-F8oy6XTovqiU7FQyuubRsiblSdvfZg9RPIyzRw2GH18=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    accelerate
    datasets
    dill
    evaluate
    jsonlines
    more-itertools
    numexpr
    peft
    pybind11
    pytablewriter
    rouge-score
    sacrebleu
    scikit-learn
    sqlitedict
    torch
    tqdm-multiprocess
    transformers
    word2number
    zstandard
  ];

  optional-dependencies = {
    api = [
      requests
      aiohttp
      tenacity
      tqdm
      tiktoken
    ];
    hf_transfer = [ hf-transfer ];
    ifeval = [
      langdetect
      immutabledict
      nltk
    ];
    neuronx = [ optimum ] ++ optimum.optional-dependencies.neuronx;
    mamba = [
      mamba-ssm
      causal-conv1d
    ];
    math = [
      sympy
      antlr4-python3-runtime
    ];
    optimum = [ optimum ] ++ optimum.optional-dependencies.openvino;
    sentencepiece = [ sentencepiece ];
    vllm = [ vllm ];
    wandb = [
      wandb
      pandas
      numpy
    ];
    # Still missing dependencies for the following:
    # deepsparse, gptq, ibm_watsonx_ai, multilingual, promptsource, sparseml,
    # zeno, gptqmodel, japanese_leaderboard; all = [...];
  };

  pythonImportsCheck = [ "lm_eval" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.api;

  preCheck = ''
    export HOME=$TMP
  '';

  disabledTests = [
    "test_deepsparse" # deepsparse is not available
    "test_model_tokenized_call_usage" # downloads a model
  ];

  disabledTestPaths = [
    # attempts to download models
    "tests/models/test_huggingface.py"
    "tests/test_evaluator.py"
    "tests/test_include_path.py"
    "tests/test_prompt.py"
    "tests/test_task_manager.py"
    "tests/test_tasks.py"

    # optimum-intel is not available
    "tests/models/test_openvino.py"
  ];

  meta = {
    changelog = "https://github.com/EleutherAI/lm-evaluation-harness/releases/tag/${src.tag}";
    description = "A framework for few-shot evaluation of language models";
    homepage = "https://github.com/EleutherAI/lm-evaluation-harness";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.booxter ];
  };
}
