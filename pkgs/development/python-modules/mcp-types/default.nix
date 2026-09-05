{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mcp,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  pydantic,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp-types";
  pyproject = true;
  __structuredAttrs = true;

  inherit (mcp) version src;

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
