{
  lib,
  attrs,
  boto3,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mock,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "aws-encryption-sdk";
  version = "4.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-encryption-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JVvcBKHLf4jMinUl6Z52PNteSS6XeaqGqZsnvJ9aSXQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    boto3
    cryptography
    wrapt
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "test" ];

  disabledTestPaths = [
    # Tests require networking
    "examples"
    "test/integration"
    # requires yet to be packaged aws-cryptographic-material-providers
    "test/mpl"
  ];

  disabledTests = [
    # pytest 8 compat issue
    "test_happy_version"
  ];

  pythonImportsCheck = [ "aws_encryption_sdk" ];

  meta = {
    description = "Python implementation of the AWS Encryption SDK";
    homepage = "https://aws-encryption-sdk-python.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-python/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
