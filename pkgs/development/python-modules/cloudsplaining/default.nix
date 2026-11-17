{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  cached-property,
  click-option-group,
  click,
  fetchFromGitHub,
  jinja2,
  markdown,
  moto,
  policy-sentry,
  pytestCheckHook,
  pyyaml,
  schema,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "cloudsplaining";
    tag = version;
    hash = "sha256-10iUNeSn71o6B4DRrCt6Yw7b/2bwCd0ZFyf9LwMAM6U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build~=0.11.0" "uv_build"
  '';

  pythonRelaxDeps = true;

  build-system = [ uv-build ];

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

  nativeCheckInputs = [
    moto
    pytestCheckHook
  ];

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
