{
  lib,
  buildPythonPackage,
  fastmcp_4,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  cryptography,
  fastmcp-slim_4,
  pydocket,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp-tasks";
  inherit (fastmcp_4) version src;
  sourceRoot = "${finalAttrs.src.name}/fastmcp_tasks";
  pyproject = true;
  __structuredAttrs = true;

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    cryptography
    fastmcp-slim_4
    pydocket
  ]
  ++ fastmcp-slim_4.optional-dependencies.server;

  pythonImportsCheck = [ "fastmcp_tasks" ];

  # upstream tests are done in the fastmcp package
  doCheck = false;

  meta = {
    description = "Background task execution for FastMCP servers";
    changelog = "https://github.com/PrefectHQ/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp/tree/main/fastmcp_tasks";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
