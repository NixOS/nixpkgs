{
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch2,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  accelerate,
  avidtools,
  backoff,
  base2048,
  cmd2,
  cohere,
  colorama,
  datasets,
  deepl,
  ecoji,
  fschat,
  ftfy,
  google-api-python-client,
  google-cloud-translate,
  grpcio-tools,
  huggingface-hub,
  jinja2,
  jsonpath-ng,
  langchain,
  langdetect,
  litellm,
  lorem,
  markdown,
  mistralai,
  nemollm,
  nltk, # also used for testing
  numpy,
  nvidia-riva-client,
  ollama,
  openai,
  pillow,
  python-magic,
  rapidfuzz,
  replicate,
  sentencepiece,
  stdlibs,
  tiktoken,
  torch,
  tqdm,
  transformers,
  wn,
  xdg-base-dirs,
  zalgolib,
  # optional audio
  librosa,
  soundfile,
  # optional calibration
  scipy,

  # test utilities
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  writeText,

  # test dependencies
  langcodes,
  pytest-httpserver,
  pytest-mock,
  requests-futures,
  requests-mock,
  respx,

}:

let
in
buildPythonPackage rec {
  pname = "garak";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "garak";
    rev = "v${version}";
    hash = "sha256-saB+vBa1POXYCVUehgLBchbpgSwpa+U/EPwU8xC2OXk=";
  };

  build-system = [
    flit-core
  ];

  pythonRelaxDeps = [
    "avidtools"
    "cmd2"
    "cohere"
    "datasets"
    "deepl"
    "mistralai"
    "nvidia-riva-client"
    "wn"
  ];

  dependencies = [
    accelerate
    avidtools
    backoff
    base2048
    cmd2
    cohere
    colorama
    datasets
    deepl
    ecoji
    fschat
    ftfy
    google-api-python-client
    google-cloud-translate
    grpcio-tools
    huggingface-hub
    jinja2
    jsonpath-ng
    langchain
    langdetect
    litellm
    lorem
    markdown
    mistralai
    nemollm
    nltk
    numpy
    nvidia-riva-client
    ollama
    openai
    pillow
    python-magic
    rapidfuzz
    replicate
    sentencepiece
    stdlibs
    tiktoken
    torch
    tqdm
    transformers
    wn
    xdg-base-dirs
    zalgolib
  ];

  optional-dependencies = {
    audio = [
      librosa
      soundfile
    ];

    calibration = [
      scipy
    ];
  };

  nativeCheckInputs = [
    writableTmpDirAsHomeHook

    pytestCheckHook

    langcodes
    pytest-httpserver
    pytest-mock
    requests-futures
    requests-mock
    respx
  ]
  ++ optional-dependencies.audio;

  pythonImportsCheck = [ "garak" ];

  # tests use localhost
  __darwinAllowLocalNetworking = true;

  passthru.test-data = {
    nltk = nltk.dataDir (d: [
      d.stopwords
      d.punkt
      d.wordnet
    ]);
    lexicon = {
      name = "oewn:2023";
      data = fetchurl {
        url = "https://en-word.net/static/english-wordnet-2023.xml.gz";
        hash = "sha256-T7+f+cYq/4djjiHJmNbltJJ6nz7y6YggOv7ZatuFxeU=";
      };
    };
    # Wrap around `wn` python lib to load pre-fetched test lexicon.
    # Can't just unpack to a dir since `wn` prepares an sqlite3 db.
    # Also can't unpack to the default `data_directory` since garak changes that
    # at runtime.
    # https://github.com/NVIDIA/garak/blob/8fd22ee19b47613b9c2b728c35739276cd46ac6a/garak/probes/topic.py#L96
    loadLexiconScript = writeText "load-lexicon-for-garak.py" ''
      import sys
      from pathlib import Path
      from garak import _config
      import wn

      if len(sys.argv) < 2:
          print("Error: No input provided.")
          sys.exit(1)

      lexicon_file = sys.argv[1]
      if not isinstance(lexicon_file, str):
          print("Error: Input is not a string.")
          sys.exit(1)

      # garak overrides the wn data_directory so use the same dir
      wn.config.data_directory = _config.transient.cache_dir / "data" / "wn"
      Path(wn.config.data_directory).mkdir(parents=True, exist_ok=True)
      print("Loading lexicon", lexicon_file, "to", wn.config.data_directory)
      wn.add(lexicon_file)
    '';
  };

  preCheck =
    # garak overrides nltk loading in garak/resources/api/nltk.py
    # and doesn't respect NLTK_DATA env var
    ''
      mkdir -p "$HOME/.cache/data/" "$HOME/.cache/huggingface/hub" "$HOME/.cache/garak/data"
      ln -s ${passthru.test-data.nltk} "$HOME/.cache/data/nltk_data"
    ''
    +
    # prepare lexicon data via `wn` for tests/probes/test_probes_topic.py
    ''
      echo "Preparing ${passthru.test-data.lexicon.name} lexicon for use in testing"
      # check TEST_LEXICON matches the one we're using
      grep -q 'TEST_LEXICON = "${passthru.test-data.lexicon.name}"' tests/probes/test_probes_topic.py \
        || (echo "TEST_LEXICON has been updated, fix in garak package definition" && exit 1)
      python ${passthru.test-data.loadLexiconScript} ${passthru.test-data.lexicon.data}
      substituteInPlace tests/probes/test_probes_topic.py \
        --replace-fail "wn.download(TEST_LEXICON)" ""
    '';

  disabledTests = [
    # around 77% of test runtime
    # handy to disable for frequent testing but leave in for real build
    # "test_repeat_token_sample_all"

    # need models from huggingface
    "test_atkgen_one_pass"
    "test_atkgen_probe"
    "test_atkgen_probe_translation"
    "test_buff_load_and_transform"
    "test_buff_results"
    "test_dont_start_no_reverse_translation"
    "test_dont_start_yes_reverse_translation"
    "test_hf_detector_detection"
    "test_hf_files_hf_repo"
    "test_instantiate_detectors"
    "test_local_translate_single_language"
    "test_model"
    "test_model_chat"
    "test_must_contradict_NLI_detection"
    "test_pipeline"
    "test_run_all_active_probes"
    "test_startswith_detect"
    "test_Tag_attempt_descrs_translation"
    "test_tox_safe"
    "test_tox_unsafe"
    "test_pipeline_chat"
    "test_rakuland_known_package"

    # runs cli, wants to fetch garak-llm/toxic-comment-model from huggingface
    # tries to access the 8th line of the jsonl report.
    # IndexError: list index out of range
    "test_attempt_sticky_params"

    # need images from github
    "test_multi_modal_probe_translation"
    "test_probe_metadata"
    "test_probes_visual_jailbreak"
    "test_cutoff_restriction"
    "test_rakuland_hallucinated_package"

    # needs content from windows.net
    "test_repeat_token_single"

    # need audio from huggingface, images from github
    "test_instantiate_probes"

    # outputs len = 10, generations probe calls = 1
    "test_leakreplay_output_count"

    # AttributeError: 'WordnetControversial' object has no attribute 'prompts'
    "test_probe_prompt_translation"

    # generally needs models from huggingface
    # AssertionError: detector should return as many results as in all_outputs (maybe excluding Nones)
    # assert 0 in (3, 4)
    # +  where 0 = len([])
    # +    where [] = list([])
    "test_detector_detect"

    # need datasets from huggingface for each language
    # e.g. garak-llm/npm-20240828, garak-llm/crates-20240903, etc
    # AssertionError: Misrecognition in core, false, or external package name validity
    "test_javascriptnpm_case_sensitive"
    "test_javascriptnpm_real"
    "test_javascriptnpm_stdlib"
    "test_javascriptnpm_weird"
    "test_pythonpypi_case_sensitive"
    "test_pythonpypi_pypi"
    "test_pythonpypi_stdlib"
    "test_pythonpypi_weird"
    "test_result_alignment"
    "test_rubygems_case_sensitive"
    "test_rubygems_real"
    "test_rubygems_stdlib"
    "test_rubygems_weird"
    "test_rustcrates_case_sensitive"
    "test_rustcrates_direct_usage"
    "test_rustcrates_real"
    "test_rustcrates_stdlib"
    "test_rustcrates_weird"

    # get warnings from where the test causes garak/_plugins.py:273 to try open missing files
    # e.g. /build/pytest-of-nixbld/pytest-0/test_llava_generate_returns_de0/test.png
    "test_create"

    "test_dart_known_package"
    "test_dart_hallucinated_package"
    "test_perl_known_package"
    "test_perl_hallucinated_package"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook # runs ahead of checks in python builds
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "LLM vulnerability scanner";
    homepage = "https://github.com/NVIDIA/garak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "garak";
  };
}
