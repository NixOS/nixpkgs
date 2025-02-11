{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  jsonpatch,
  langsmith,
  packaging,
  pyyaml,
  tenacity,
  typing-extensions,

  # optional-dependencies
  pydantic,

  # tests
  freezegun,
  grandalf,
  httpx,
  langchain-core,
  langchain-tests,
  numpy,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  syrupy,

  # passthru
  writeScript,
}:

buildPythonPackage rec {
  pname = "langchain-core";
  version = "0.3.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-u+Za7NtXVP0Mg6K65CuRLx8OrVpBXEe1ayP0uMUNJG4=";
  };

  sourceRoot = "${src.name}/libs/core";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "tenacity" ];

  dependencies = [
    jsonpatch
    langsmith
    packaging
    pyyaml
    tenacity
    typing-extensions
  ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  pythonImportsCheck = [ "langchain_core" ];

  # avoid infinite recursion
  doCheck = false;

  nativeCheckInputs = [
    freezegun
    grandalf
    httpx
    langchain-tests
    numpy
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  passthru = {
    tests.pytest = langchain-core.overridePythonAttrs (_: {
      doCheck = true;
    });
    # Updates to core tend to drive updates in everything else
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -u -o pipefail +e
      # Common core
      nix-update --commit --version-regex 'langchain-core==(.*)' python3Packages.langchain-core
      nix-update --commit --version-regex 'langchain-text-splitters==(.*)' python3Packages.langchain-text-splitters
      nix-update --commit --version-regex 'langchain==(.*)' python3Packages.langchain
      nix-update --commit --version-regex 'langchain-community==(.*)' python3Packages.langchain-community

      # Extensions
      nix-update --commit --version-regex 'langchain-aws==(.*)' python3Packages.langchain-aws
      nix-update --commit --version-regex 'langchain-azure-dynamic-sessions==(.*)' python3Packages.langchain-azure-dynamic-sessions
      nix-update --commit --version-regex 'langchain-chroma==(.*)' python3Packages.langchain-chroma
      nix-update --commit --version-regex 'langchain-huggingface==(.*)' python3Packages.langchain-huggingface
      nix-update --commit --version-regex 'langchain-mongodb==(.*)' python3Packages.langchain-mongodb
      nix-update --commit --version-regex 'langchain-openai==(.*)' python3Packages.langchain-openai
    '';
    # updates the wrong fetcher rev attribute
    skipBulkUpdate = true;
  };

  disabledTests =
    [
      # flaky, sometimes fail to strip uuid from AIMessageChunk before comparing to test value
      "test_map_stream"
      # Compares with machine-specific timings
      "test_rate_limit"
      # flaky: assert (1726352133.7419367 - 1726352132.2697523) < 1
      "test_benchmark_model"

      # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
      "test_chat_prompt_template_variable_names"
      "test_create_model_v2"

      # Comparison with magic strings
      "test_prompt_with_chat_model"
      "test_prompt_with_chat_model_async"
      "test_prompt_with_llm"
      "test_prompt_with_llm_parser"
      "test_prompt_with_llm_and_async_lambda"
      "test_prompt_with_chat_model_and_parser"
      "test_combining_sequences"

      # AssertionError: assert [+ received] == [- snapshot]
      "test_chat_input_schema"
      # AssertionError: assert {'$defs': {'D...ype': 'array'} == {'$defs': {'D...ype': 'array'}
      "test_schemas"
      # AssertionError: assert [+ received] == [- snapshot]
      "test_graph_sequence_map"
      "test_representation_of_runnables"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Langchain-core the following tests due to the test comparing execution time with magic values.
      "test_queue_for_streaming_via_sync_call"
      "test_same_event_loop"
      # Comparisons with magic numbers
      "test_rate_limit_ainvoke"
      "test_rate_limit_astream"
    ];

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/core";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
