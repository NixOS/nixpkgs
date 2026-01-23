{
  lib,
  awscrt,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "awsiotsdk";
  version = "1.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python-v2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cs+MbI/23bPvdZNaze7ENyEZNT/AVYsPz/dEEzaAy8c=";
  };

  postPatch = ''
    substituteInPlace awsiot/__init__.py \
      --replace-fail  "__version__ = '1.0.0-dev'" "__version__ = '${finalAttrs.version}'"
  '';

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
    changelog = "https://github.com/aws/aws-iot-device-sdk-python-v2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
