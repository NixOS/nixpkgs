{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "AWSIoTPythonSDK";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-GHMnDRxXkaKDTaawwPtMqa7EZJ8Y35+ScgtfEP9PJGs=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AWSIoTPythonSDK"
  ];

  meta = with lib; {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
