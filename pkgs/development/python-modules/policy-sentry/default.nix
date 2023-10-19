{ lib
, beautifulsoup4
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, schema
}:

buildPythonPackage rec {
  pname = "policy-sentry";
  version = "0.12.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    rev = "refs/tags/${version}";
    hash = "sha256-Kha5fq5l1yXWjDZq9GFKk3gYRtrEyiCFjbEAdYGPSa8=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    click
    requests
    pyyaml
    schema
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "policy_sentry"
  ];

  meta = with lib; {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
