{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  dagster,
  gql,
  graphene,
  requests-toolbelt,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-graphql";
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "dagster_graphql";
    hash = "sha256-740NWSw8hmIi977f8CEv1Ri9oF+BWzSu4r+CAJ6jJ20=";
  };

  build-system = [ hatchling ];

  dependencies = [
    dagster
    gql
    graphene
    requests-toolbelt
    starlette
  ];

  pythonImportsCheck = [ "dagster_graphql" ];

  meta = {
    description = "GraphQL API for Dagster";
    homepage = "https://dagster.io";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
