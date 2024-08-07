{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  orjson,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "policy-sentry";
  version = "0.13.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    rev = "refs/tags/${version}";
    hash = "sha256-J6dLKmfZJSU9k64PzOAOTgYvRf9NCpWtYuFEUxrfT5M=";
  };

  build-system = [ setuptools ];

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

  meta = with lib; {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "policy_sentry";
  };
}
