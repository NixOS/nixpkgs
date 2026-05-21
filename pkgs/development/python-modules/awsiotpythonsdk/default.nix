{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "awsiotpythonsdk";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jwj07yAl9LrHRy1y3cjipObqEcwP+j+a5dcvXj02kgA=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "AWSIoTPythonSDK" ];

  meta = {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    changelog = "https://github.com/aws/aws-iot-device-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
