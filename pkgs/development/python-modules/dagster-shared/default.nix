{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  platformdirs,
  pydantic,
  pyyaml,
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-shared";
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "dagster_shared";
    hash = "sha256-QRastaeKrIUgJ+Q+utkURx6YME/q15kvBMO67Dn6DS0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    platformdirs
    pydantic
    pyyaml
    tomlkit
  ];

  pythonImportsCheck = [ "dagster_shared" ];

  meta = {
    description = "Shared utilities and types used across the Dagster ecosystem";
    homepage = "https://github.com/dagster-io/dagster/tree/master/python_modules/libraries/dagster-shared";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lucperkins
    ];
  };
})
