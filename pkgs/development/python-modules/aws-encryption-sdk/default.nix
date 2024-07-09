{
  lib,
  attrs,
  boto3,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  mock,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6yrboU9IHNg9cWmrjmQplIltOaSmTheWkEprSSVmE7A=";
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

  disabledTestPaths = [
    # Tests require networking
    "examples"
    "test/integration"
  ];

  disabledTests = [
    # pytest 8 compat issue
    "test_happy_version"
  ];

  pythonImportsCheck = [ "aws_encryption_sdk" ];

  meta = with lib; {
    description = "Python implementation of the AWS Encryption SDK";
    homepage = "https://aws-encryption-sdk-python.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-python/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
