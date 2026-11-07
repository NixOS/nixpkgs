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
  redis,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp-tasks";
  inherit (fastmcp) version src;
  sourceRoot = "${finalAttrs.src.name}/fastmcp_tasks";
  pyproject = true;
  __structuredAttrs = true;

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    # Upstream excludes 8.1.0 until https://github.com/redis/redis-py/pull/4260 is released
    "redis"
  ];
  dependencies = [
    cryptography
    fastmcp-slim
    pydocket
    redis
  ]
  ++ fastmcp-slim.optional-dependencies.server;

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
