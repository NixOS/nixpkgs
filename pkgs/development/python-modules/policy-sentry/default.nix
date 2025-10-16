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
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    tag = version;
    hash = "sha256-o4l4jkh9ZNqc3Jovd10KUQLDBLn0sPWdgScq5Q2qd14=";
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
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "policy_sentry";
  };
}
