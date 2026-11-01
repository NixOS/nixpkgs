{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "caido-schema-proxy";
  version = "0.59.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "caido_schema_proxy";
    inherit (finalAttrs) version;
    hash = "sha256-+Cqothi0ubsTVPLX6r2iHW/BhvOx5oLSwTpIkiCK3zY=";
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
