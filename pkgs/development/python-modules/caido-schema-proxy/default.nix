{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "caido-schema-proxy";
  version = "0.57.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "caido_schema_proxy";
    inherit (finalAttrs) version;
    hash = "sha256-gIElEhHnMDfz6hu0UTOtTiYaB/ZnfeBCskEWTM9419M=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "caido_schema_proxy" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Caido Proxy API schemas (GraphQL and OpenAPI)";
    homepage = "https://pypi.org/project/caido-schema-proxy";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ fab ];
  };
})
