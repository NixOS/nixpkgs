{
  lib,
  awscrt,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "awsiotsdk";
  version = "1.22.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python-v2";
    rev = "refs/tags/v${version}";
    hash = "sha256-2ZMNG+6yshEvjEpyN6uV62m11LZUrUHAzpRbm1foif0=";
  };

  pythonRelaxDeps = [ "awscrt" ];

  build-system = [ setuptools ];

  dependencies = [ awscrt ];

  nativeCheckInputs = [
    boto3
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Those tests require a custom loader
    "servicetests/"
  ];

  pythonImportsCheck = [ "awsiot" ];

  meta = {
    description = "Next generation AWS IoT Client SDK for Python using the AWS Common Runtime";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python-v2";
    changelog = "https://github.com/aws/aws-iot-device-sdk-python-v2/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
