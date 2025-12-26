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

buildPythonPackage rec {
  pname = "py-ocsf-models";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-ocsf-models";
    tag = version;
    hash = "sha256-8HtX0kbd+5oYtzRpH3JtdyV+K+n+FWOQQ5CpJ+pejEo=";
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
