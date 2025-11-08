{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "awsiotpythonsdk";
  version = "1.5.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    changelog = "https://github.com/aws/aws-iot-device-sdk-python/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
