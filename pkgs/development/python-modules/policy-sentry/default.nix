{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  orjson,
  pytestCheckHook,
  pyyaml,
  requests,
  schema,
}:

buildPythonPackage rec {
  pname = "policy-sentry";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    tag = version;
    hash = "sha256-G7V3BqgJs9nyvhZ9xzNwP50yz+2SZfps/gsW6U8eisk=";
  };

  pythonRelaxDeps = [ "beautifulsoup4" ];

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    click
    orjson
    pyyaml
    requests
    schema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "policy_sentry" ];

  meta = {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "policy_sentry";
  };
}
