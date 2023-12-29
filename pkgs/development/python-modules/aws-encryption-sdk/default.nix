{ lib
, buildPythonPackage
, fetchPypi
, attrs
, boto3
, cryptography
, setuptools
, wrapt
, mock
, pytest
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jV+/AY/GjWscrL5N0Df9gFKWx3Nqn+RX62hNBT9/lWM=";
  };

  propagatedBuildInputs = [
    attrs
    boto3
    cryptography
    setuptools
    wrapt
  ];

  doCheck = true;

  nativeCheckInputs = [
    mock
    pytest
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires networking
    "examples"
    "test/integration"
  ];

  meta = with lib; {
    homepage = "https://aws-encryption-sdk-python.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-python/blob/v${version}/CHANGELOG.rst";
    description = "Fully compliant, native Python implementation of the AWS Encryption SDK.";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
