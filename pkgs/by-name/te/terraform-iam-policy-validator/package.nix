{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "terraform-iam-policy-validator";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "terraform-iam-policy-validator";
    tag = "v${version}";
    hash = "sha256-RGZqnt2t+aSNGt8Ubi2dzZE04n9Zfkw+T3Zmol/FO+I=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    boto3
    pyyaml
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # Some tests require network
  disabledTestPaths = [ "test/test_accessAnalyzer.py" ];

  # Tests need to be run relative to a subdir
  preCheck = ''
    pushd iam_check
  '';
  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "iam_check" ];

  meta = {
    description = "CLI tool that validates AWS IAM Policies in a Terraform template against AWS IAM best practices";
    homepage = "https://github.com/awslabs/terraform-iam-policy-validator";
    changelog = "https://github.com/awslabs/terraform-iam-policy-validator/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "tf-policy-validator";
  };
}
