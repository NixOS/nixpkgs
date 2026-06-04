{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  dagster-graphql,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-webserver";
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "dagster_webserver";
    hash = "sha256-Kdpr8c6Ik9P1Ptor4O3+jrDm7FzEQTny33jwyz6CUzE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    dagster-graphql
    uvicorn
  ];

  pythonImportsCheck = [ "dagster_webserver" ];

  meta = {
    description = "Web UI and server for Dagster";
    homepage = "https://dagster.io";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "dagster-webserver";
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
