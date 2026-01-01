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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyyaml,
  schema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
<<<<<<< HEAD
  version = "0.8.2";
  pyproject = true;

=======
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "cloudsplaining";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Abp/uvH1IYO/rb2o+7uI0Ef6q7K6T0kN1mo+Qit438E=";
  };

  pythonRelaxDeps = true;
=======
    hash = "sha256-Ix4SlkGMtserksazXCk0XcDhmxNcfV/QCVsDJjWbu2k=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" requirements.txt
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    changelog = "https://github.com/salesforce/cloudsplaining/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    changelog = "https://github.com/salesforce/cloudsplaining/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cloudsplaining";
  };
}
