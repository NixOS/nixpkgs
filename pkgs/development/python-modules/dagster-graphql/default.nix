{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,

  dagster,
  gql,
  graphene,
  requests,
  requests-toolbelt,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-graphql";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/dagster-graphql";

  build-system = [ hatchling ];

  dependencies = [
    dagster
    gql
    graphene
    requests
    # Upstream depends on `gql[requests]`; pull in the `requests-toolbelt`
    # transitive that the gql.transport.requests module imports at top level.
    requests-toolbelt
    starlette
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_graphql" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "GraphQL layer for interacting with a Dagster instance";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
    mainProgram = "dagster-graphql";
  };
})
