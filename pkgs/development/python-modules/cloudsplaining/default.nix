{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  cached-property,
  click,
  click-option-group,
  fetchFromGitHub,
  jinja2,
  markdown,
  policy-sentry,
  pytestCheckHook,
  pyyaml,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "cloudsplaining";
    tag = version;
    hash = "sha256-Abp/uvH1IYO/rb2o+7uI0Ef6q7K6T0kN1mo+Qit438E=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    boto3
    botocore
    cached-property
    click
    click-option-group
    jinja2
    markdown
    policy-sentry
    pyyaml
    schema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_policy_expansion"
    "test_statement_details_for_allow_not_action"
  ];

  pythonImportsCheck = [ "cloudsplaining" ];

  meta = {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    changelog = "https://github.com/salesforce/cloudsplaining/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudsplaining";
  };
}
