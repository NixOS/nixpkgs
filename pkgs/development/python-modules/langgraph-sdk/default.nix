{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  httpx-sse,
  orjson,
  poetry-core,
  pythonOlder,
  writeScript,
}:

buildPythonPackage rec {
  pname = "langgraph-sdk";
  version = "0.1.26";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/sdk==${version}";
    hash = "sha256-o7JrB2WSWfPm927tDRMcjzx+6Io6Q+Yjp4XPVs2+F4o=";
  };

  sourceRoot = "${src.name}/libs/sdk-py";

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    httpx-sse
    orjson
  ];

  pythonImportsCheck = [ "langgraph_sdk" ];

  passthru = {
    # python3Packages.langgraph-sdk depends on python3Packages.langgraph. langgraph-cli is independent of both.
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -eu -o pipefail
      nix-update --commit --version-regex '(.*)' python3Packages.langgraph
      nix-update --commit --version-regex 'sdk==(.*)' python3Packages.langgraph-sdk
    '';
  };

  meta = {
    description = "SDK for interacting with the LangGraph Cloud REST API";
    homepage = "https://github.com/langchain-ai/langgraphtree/main/libs/sdk-py";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/sdk==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
