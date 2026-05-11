{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-pipes";
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "dagster_pipes";
    hash = "sha256-qbmWXh7/XcE91nl2KK441WFD7tYXTeS33g9bVN61lvo=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "dagster_pipes" ];

  meta = {
    description = "Lightweight library for orchestration-aware execution from Dagster, runnable in any Python subprocess";
    homepage = "https://docs.dagster.io/concepts/dagster-pipes";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lucperkins
    ];
  };
})
