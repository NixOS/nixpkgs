{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  grandalf,
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
  pythonRelaxDepsHook,
  pyyaml,
  syrupy,
  tenacity,
  writeScript,
}:

buildPythonPackage rec {
  pname = "langchain-core";
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "langchain-core==${version}";
    hash = "sha256-MmWgnpOO+OWUyRUBqIKuIHG2/p8NfSlVJVbUXfF4spg=";
  };

  sourceRoot = "${src.name}/libs/core";

  pythonRelaxDeps = [
    "langsmith"
    "packaging"
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    jsonpatch
    langsmith
    packaging
    pydantic
    pyyaml
    tenacity
  ];

  pythonImportsCheck = [ "langchain_core" ];

  nativeCheckInputs = [
    freezegun
    grandalf
    numpy
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  disabledTests = [
    # Fail for an unclear reason with:
    # AssertionError: assert '6a92363c-4ac...-d344769ab6ac' == '09af124a-2ed...-671c64c72b70'
    "test_config_traceable_handoff"
    "test_config_traceable_async_handoff"
  ];

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

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/core";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
