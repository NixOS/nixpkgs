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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-ocsf-models";
    rev = "refs/tags/${version}";
    hash = "sha256-cFtWPO78KRh7IY+ePTzXpLPbZm+EtNvuJkhZZzKKjaA=";
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
    changelog = "https://github.com/prowler-cloud/py-ocsf-models/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
