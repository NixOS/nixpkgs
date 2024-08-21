{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  grandalf,
  httpx,
  jsonpatch,
  langsmith,
  numpy,
  packaging,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  syrupy,
  tenacity,
  writeScript,
}:

buildPythonPackage rec {
  pname = "langchain-core";
  version = "0.2.33";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-vM3FY9E8PeC8LHP4QCTM1ggFynI+PscF7pv7CMaSZlU=";
  };

  sourceRoot = "${src.name}/libs/core";

  preConfigure = ''
    ln -s ${src}/libs/standard-tests/langchain_standard_tests ./langchain_standard_tests

    substituteInPlace pyproject.toml \
      --replace-fail "path = \"../standard-tests\"" "path = \"./langchain_standard_tests\""
  '';

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

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -eu -o pipefail
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
