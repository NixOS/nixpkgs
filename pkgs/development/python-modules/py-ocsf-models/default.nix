{
  lib,
  buildPythonPackage,
  cryptography,
  email-validator,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "py-ocsf-models";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-ocsf-models";
    tag = version;
    hash = "sha256-OCHhqsP0RlqBPvK4e6m5v3/W6N7T/rzp0xL950dY//A=";
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
    changelog = "https://github.com/prowler-cloud/py-ocsf-models/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
