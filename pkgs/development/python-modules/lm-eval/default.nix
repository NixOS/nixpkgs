{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  accelerate,
  datasets,
  dill,
  evaluate,
  jsonlines,
  more-itertools,
  numexpr,
  peft,
  pybind11,
  pytablewriter,
  rouge-score,
  sacrebleu,
  scikit-learn,
  sqlitedict,
  torch,
  tqdm-multiprocess,
  transformers,
  word2number,
  zstandard,

  # optional-dependencies
  # api
  aiohttp,
  requests,
  tenacity,
  tiktoken,
  tqdm,
  # hf_transfer
  hf-transfer,
  # ifeval
  immutabledict,
  langdetect,
  nltk,
  # neuronx
  optimum,
  # mamba
  causal-conv1d,
  mamba-ssm,
  # math
  antlr4-python3-runtime,
  sympy,
  # sentencepiece
  sentencepiece,
  # vllm
  vllm,
  # wandb
  numpy,
  pandas,
  wandb,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "lm-eval";
  version = "0.4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EleutherAI";
    repo = "lm-evaluation-harness";
    tag = "v${version}";
    hash = "sha256-N5NRRabjWxPchwOIkjqYTCKInCmVSY6T5cAmdxNbCkU=";
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
      aiohttp
      requests
      tenacity
      tiktoken
      tqdm
    ];
    hf_transfer = [ hf-transfer ];
    ifeval = [
      immutabledict
      langdetect
      nltk
    ];
    neuronx = [ optimum ] ++ optimum.optional-dependencies.neuronx;
    mamba = [
      causal-conv1d
      mamba-ssm
    ];
    math = [
      antlr4-python3-runtime
      sympy
    ];
    optimum = [ optimum ] ++ optimum.optional-dependencies.openvino;
    sentencepiece = [ sentencepiece ];
    vllm = [ vllm ];
    wandb = [
      numpy
      pandas
      wandb
    ];
    # Still missing dependencies for the following:
    # deepsparse, gptq, ibm_watsonx_ai, multilingual, promptsource, sparseml,
    # zeno, gptqmodel, japanese_leaderboard; all = [...];
  };

  pythonRelaxDeps = [ "datasets" ];

  pythonImportsCheck = [ "lm_eval" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.api;

  disabledTests = [
    "test_deepsparse" # deepsparse is not available

    # download models from the internet
    "test_get_batched_requests_with_no_ssl"
    "test_model_tokenized_call_usage"
  ];

  disabledTestPaths = [
    # attempts to download models
    "tests/models/test_huggingface.py"
    "tests/test_evaluator.py"
    "tests/test_include_path.py"
    "tests/test_prompt.py"
    "tests/test_task_manager.py"
    "tests/test_tasks.py"
    "tests/test_unitxt_tasks.py"

    # optimum-intel is not available
    "tests/models/test_openvino.py"

    # zeno-client is not packaged
    "tests/scripts/test_zeno_visualize.py"
  ];

  meta = {
    changelog = "https://github.com/EleutherAI/lm-evaluation-harness/releases/tag/${src.tag}";
    description = "Framework for few-shot evaluation of language models";
    homepage = "https://github.com/EleutherAI/lm-evaluation-harness";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.booxter ];
  };
}
