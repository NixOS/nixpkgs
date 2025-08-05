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
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kRqQCYBzLlCbhuBEP+O9zuSAdgpGDg9wLzYFZaIPOIg=";
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
    # requires yet to be packaged aws-cryptographic-material-providers
    "test/mpl"
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
