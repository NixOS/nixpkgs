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

  # `mcp_types` has no test suite of its own: it is covered by the `mcp` tests
  doCheck = false;

  meta = {
    description = "Model Context Protocol wire types";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
