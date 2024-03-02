{ lib
, attrs
, boto3
, buildPythonPackage
, cryptography
, fetchPypi
, mock
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, wrapt
}:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jV+/AY/GjWscrL5N0Df9gFKWx3Nqn+RX62hNBT9/lWM=";
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

  disabledTestPaths = [
    # Tests require networking
    "examples"
    "test/integration"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # AssertionError: Regex pattern did not match, https://github.com/aws/aws-encryption-sdk-python/issues/644
    "test_abstracts"
  ];

  meta = with lib; {
    description = "Python implementation of the AWS Encryption SDK";
    homepage = "https://aws-encryption-sdk-python.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-python/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
