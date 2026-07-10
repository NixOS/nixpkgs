{
  lib,
  buildPythonPackage,
  email-validator,
  fetchFromGitHub,
  flowsint,
  phonenumbers,
  poetry-core,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowsint-types";
  pyproject = true;

  inherit (flowsint) src version;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ poetry-core ];

  dependencies = [
    email-validator
    phonenumbers
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flowsint_types" ];

  meta = {
    description = "Pydantic models for flowsint";
    homepage = "https://github.com/reconurge/flowsint/blob/main/flowsint-types";
    changelog = "https://github.com/reconurge/flowsint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
