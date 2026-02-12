{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  accelerate,
  datasets,
  dill,
  evaluate,
  jinja2,
  jsonlines,
  more-itertools,
  peft,
  pytablewriter,
  rouge-score,
  sacrebleu,
  scikit-learn,
  sqlitedict,
  torch,
  transformers,
  typing-extensions,
  word2number,
  zstandard,

  # optional-dependencies
  aiohttp,
  hf-transfer,
  immutabledict,
  langdetect,
  librosa,
  nltk,
  numpy,
  optimum,
  pandas,
  pymorphy2,
  requests,
  sentencepiece,
  soundfile,
  statsmodels,
  tenacity,
  tiktoken,
  tqdm,
  vllm,
  wandb,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lm-eval";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EleutherAI";
    repo = "lm-evaluation-harness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+fVLpJ/wzFyQJkdlHTirTNrtWg7Vn26kU0OV4+oDJXA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    datasets
    dill
    evaluate
    jinja2
    jsonlines
    more-itertools
    pytablewriter
    rouge-score
    sacrebleu
    scikit-learn
    sqlitedict
    typing-extensions
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
    audiolm_qwen = [
      librosa
      soundfile
    ];
    discrim_eval = [ statsmodels ];
    hf = [
      accelerate
      peft
      torch
      transformers
    ];
    hf_transfer = [ hf-transfer ];
    ifeval = [
      immutabledict
      langdetect
      nltk
    ];
    libra = [
      pymorphy2
    ];
    optimum = [ optimum ] ++ optimum.optional-dependencies.openvino;
    sentencepiece = [ sentencepiece ];
    vllm = [ vllm ];
    wandb = [
      numpy
      pandas
      wandb
    ];
    # Still missing dependencies for the following optional dependency groups:
    # - acpbench
    # - deepsparse
    # - gptq
    # - gptqmodel
    # - ibm_watsonx_ai
    # - ipex
    # - japanese_leaderboard
    # - longbench
    # - math
    # - multilingual
    # - ruler
    # - sae_lens
    # - sparsify
    # - tasks
    # - unitxt
    # - zeno
  };

  pythonRelaxDeps = [ "datasets" ];

  pythonImportsCheck = [ "lm_eval" ];

  nativeCheckInputs = [
    pytestCheckHook
    sentencepiece
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.api
  ++ finalAttrs.passthru.optional-dependencies.hf;

  disabledTests = [
    "test_deepsparse" # deepsparse is not available

    # download models from the internet
    "test_get_batched_requests_with_no_ssl"
    "test_model_tokenized_call_usage"
  ];

  disabledTestPaths = [
    # attempts to download models
    "tests/models/test_bos_handling.py"
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
    changelog = "https://github.com/EleutherAI/lm-evaluation-harness/releases/tag/${finalAttrs.src.tag}";
    description = "Framework for few-shot evaluation of language models";
    homepage = "https://github.com/EleutherAI/lm-evaluation-harness";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.booxter ];
  };
})
