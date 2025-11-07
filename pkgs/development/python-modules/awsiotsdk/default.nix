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
  version = "1.26.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python-v2";
    tag = "v${version}";
    hash = "sha256-FK/Sy2zxWqrLmBiJO80PdBp/NJWV9OujFffCk7CG7jk=";
  };

  postPatch = ''
    substituteInPlace awsiot/__init__.py \
      --replace-fail  "__version__ = '1.0.0-dev'" "__version__ = '${version}'"
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
    changelog = "https://github.com/aws/aws-iot-device-sdk-python-v2/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
