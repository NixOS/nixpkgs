{
  lib,
  buildPythonPackage,
  fastmcp,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  cryptography,
  fastmcp-slim,
  pydocket,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp-tasks";
  inherit (fastmcp) version src;
  sourceRoot = "${finalAttrs.src.name}/fastmcp_tasks";
  pyproject = true;

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    cryptography
    fastmcp-slim
    pydocket
  ]
  ++ fastmcp-slim.optional-dependencies.server;

  pythonImportsCheck = [ "fastmcp_tasks" ];

  # upstream tests are done in fastmcp package
  doCheck = false;

  meta = {
    description = "Background task execution for FastMCP servers via the MCP tasks extension";
    changelog = "https://github.com/PrefectHQ/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp/tree/main/fastmcp_tasks";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
