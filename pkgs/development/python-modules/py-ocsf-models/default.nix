{
  lib,
  buildPythonPackage,
  cryptography,
  email-validator,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-ocsf-models";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-ocsf-models";
    tag = finalAttrs.version;
    hash = "sha256-Wtls4Ei1160hxvZjdyH0rJCQWEN/CwpxfllwgGTzMog=";
  };

  pythonRelaxDeps = true;

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    email-validator
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "py_ocsf_models" ];

  meta = {
    description = "OCSF models in Python using Pydantic";
    homepage = "https://github.com/prowler-cloud/py-ocsf-models";
    changelog = "https://github.com/prowler-cloud/py-ocsf-models/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
