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
  pythonOlder,
  pyyaml,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "cloudsplaining";
    rev = "refs/tags/${version}";
    hash = "sha256-mRWfb14zKS141cYzShXY+OoHWfs9PB1oJu3spsvv6mI=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" requirements.txt
  '';

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

  meta = with lib; {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    changelog = "https://github.com/salesforce/cloudsplaining/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cloudsplaining";
  };
}
