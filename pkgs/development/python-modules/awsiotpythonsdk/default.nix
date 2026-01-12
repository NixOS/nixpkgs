{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "awsiotpythonsdk";
  version = "1.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    tag = "v${version}";
    hash = "sha256-mgf2hb7dWOGzaHnOQDz7GJeQV3Pa0X56X8nC15Tq0dY=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "AWSIoTPythonSDK" ];

  meta = {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    changelog = "https://github.com/aws/aws-iot-device-sdk-python/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
