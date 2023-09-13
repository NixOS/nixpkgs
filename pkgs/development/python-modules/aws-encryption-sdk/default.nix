{ lib
, buildPythonPackage
, fetchPypi
, wrapt
, cryptography
, attrs
, boto3
, pytestCheckHook
, pytest-mock
, mock
}:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "3.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qwmgwzhakb8xdby97vafg3rcll0zlvx0kdymhf6p3f6iw0vypwd";
  };

  propagatedBuildInputs = [
    wrapt
    cryptography
    attrs
    boto3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    mock
  ];

  disabledTestPaths = [
    # All of these (save one in the wildchar) requires a AWS token/credential
    "examples/test/*.py"
    "test/integration/test_i_thread_safety.py"
    "test/integration/test_i_aws_encrytion_sdk_client.py"
  ];

  disabledTests = [
    # touches network
    "KMS key provider"
    # requires AWS credentials
    "Simple JS encrypt"
   ];

  meta = {
    description = "AWS Encryption SDK implementation for Python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sree ];
    homepage = "https://github.com/aws/aws-encryption-sdk-python";
  };
}
