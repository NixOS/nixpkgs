{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  prefect,
  redis,
}:
buildPythonPackage (finalAttrs: {
  pname = "prefect-redis";
  version = "0.2.11";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "prefect";
    tag = "prefect-redis-${finalAttrs.version}";
    hash = "sha256-mYqQKebUDwTpELUmWDkEFSUmxwM69AOw7rJOxgUiYbM=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/integrations/prefect-redis";
  dependencies = [
    prefect
    redis
  ];
  build-system = [
    setuptools
    setuptools-scm
  ];
  meta = {
    description = "Redis integration for Prefect";
    homepage = "https://github.com/PrefectHQ/prefect/tree/main/src/integrations/prefect-redis";
    changelog = "https://github.com/PrefectHQ/prefect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
