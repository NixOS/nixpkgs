{
  lib,
  buildPythonPackage,
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
  inherit (mcp) version src;
  pyproject = true;
  __structuredAttrs = true;

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

  # tested by mcp
  doCheck = false;

  meta = {
    description = "Model Context Protocol wire types";
    homepage = "https://github.com/modelcontextprotocol/python-sdk/tree/main/src/mcp-types";
    inherit (mcp.meta) changelog license maintainers;
  };
})
