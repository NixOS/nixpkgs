{
  lib,
  buildPythonPackage,
  mcp_2,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  pydantic,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp-types";
  inherit (mcp_2) version src;
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

  # tested by mcp_2
  doCheck = false;

  meta = {
    description = "Model Context Protocol wire types";
    homepage = "https://github.com/modelcontextprotocol/python-sdk/tree/main/src/mcp-types";
    inherit (mcp_2.meta) changelog license maintainers;
  };
})
