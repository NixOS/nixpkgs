{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  pydantic,
  email-validator,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jambo";
  version = "0.1.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-34mrggnr33pukiUuySWXnNPTKBG/SoGCqX3DW331j3Q=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pydantic
    email-validator
    jsonschema
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jambo" ];

  meta = {
    description = "Pydantic-powered schema and serialization utilities for the ArchiveBox plugin ecosystem";
    homepage = "https://github.com/ArchiveBox/jambo";
    changelog = "https://github.com/HideyoshiNakazone/jambo/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
