{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "policy-sentry";
  version = "0.12.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    rev = "refs/tags/${version}";
    hash = "sha256-1LYcUlGoSalbdo4tiNIYbdA04IHRTImhdWScpiCZk50=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    click
    requests
    pyyaml
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
