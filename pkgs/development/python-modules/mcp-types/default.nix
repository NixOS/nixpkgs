{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  pydantic,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp-types";
  version = "2.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3qS18hgOxLjm+IEa/knkfyh0Cz2QFtyqxXTZJepevU=";
  };

  # TODO: uncomment after bootstrap
  # inherit (mcp) version src;

  sourceRoot = "${finalAttrs.src.name}/src/mcp-types";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "mcp_types" ];

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    description = "Model Context Protocol wire types";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      daniel-fahey
    ];
  };
})
