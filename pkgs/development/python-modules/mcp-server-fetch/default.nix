{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  markdownify,
  mcp,
  protego,
  pydantic,
  readabilipy,
  requests,
  callPackage,
}:
buildPythonPackage rec {
  pname = "mcp-server-fetch";
  version = "2025.3.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = version;
    hash = "sha256-6362x1vFLDMvcPNeS91juO/nZB51el48zOamIQrSeZw=";
  };
  sourceRoot = "${src.name}/src/fetch";

  build-system = [
    hatchling
  ];

  dependencies = [
    markdownify
    mcp
    protego
    pydantic
    readabilipy
    requests
  ];

  passthru.tests = {
    help = callPackage ./tests/help.nix { };
  };

  meta = {
    description = "Model Context Protocol server providing tools to fetch and convert web content for usage by LLMs";
    homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/fetch";
    changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josh ];
    mainProgram = "mcp-server-fetch";
  };
}
