{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "awsiotpythonsdk";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GHMnDRxXkaKDTaawwPtMqa7EZJ8Y35+ScgtfEP9PJGs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AWSIoTPythonSDK"
  ];

  meta = with lib; {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    changelog = "https://github.com/aws/aws-iot-device-sdk-python/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
