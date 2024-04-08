{ lib
, attrs
, boto3
, buildPythonPackage
, cryptography
, fetchPypi
, mock
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
, wrapt
}:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QwT8+M4qo/qYsaz/ejvzzQUowynAxDe1Xg9Fa79iNH4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pytestFlagsArray = [
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  disabledTestPaths = [
    # Tests require networking
    "examples"
    "test/integration"
  ];

  pythonImportsCheck = [
    "aws_encryption_sdk"
  ];

  meta = with lib; {
    description = "Python implementation of the AWS Encryption SDK";
    homepage = "https://aws-encryption-sdk-python.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-python/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
