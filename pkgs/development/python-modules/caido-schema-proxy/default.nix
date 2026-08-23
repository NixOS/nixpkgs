{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "caido-schema-proxy";
  version = "0.58.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "caido_schema_proxy";
    inherit (finalAttrs) version;
    hash = "sha256-1vGmDivVqx3XN1CUR/XwgYTG/mwI6Zny0Nv8AKUpOa4=";
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
