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

  # optional-dependencies
  pydantic,

  # tests
  freezegun,
  grandalf,
  httpx,
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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-BCqrJuy7R2jT3QmTvYwn8gHX7bc6Tq8HArK+F3PjBhw=";
  };

  sourceRoot = "${src.name}/libs/core";

  build-system = [ poetry-core ];

  dependencies = [
    jsonpatch
    langsmith
    packaging
    pyyaml
    tenacity
  ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  pythonImportsCheck = [ "langchain_core" ];

  nativeCheckInputs = [
    freezegun
    grandalf
    httpx
    numpy
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  # don't add langchain-standard-tests to nativeCheckInputs
  # to avoid circular import
  preCheck = ''
    export PYTHONPATH=${src}/libs/standard-tests:$PYTHONPATH
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -u -o pipefail +e
      nix-update --commit --version-regex 'langchain-core==(.*)' python3Packages.langchain-core
      nix-update --commit --version-regex 'langchain-text-splitters==(.*)' python3Packages.langchain-text-splitters
      nix-update --commit --version-regex 'langchain==(.*)' python3Packages.langchain
      nix-update --commit --version-regex 'langchain-community==(.*)' python3Packages.langchain-community
    '';
  };

  disabledTests =
    [
      # flaky, sometimes fail to strip uuid from AIMessageChunk before comparing to test value
      "test_map_stream"
      # Compares with machine-specific timings
      "test_rate_limit_invoke"
      "test_rate_limit_stream"
      # flaky: assert (1726352133.7419367 - 1726352132.2697523) < 1
      "test_benchmark_model"

      # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
      "test_chat_prompt_template_variable_names"
      "test_create_model_v2"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
