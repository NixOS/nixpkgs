{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "AWSIoTPythonSDK";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    rev = "v${version}";
    sha256 = "0bmvwv471mvlwj2rfz08j9qvzsp4vyjz67cbzkvsy6kmihx3wfqh";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "AWSIoTPythonSDK" ];

  meta = with lib; {
    description = "Python SDK for connecting to AWS IoT";
    homepage = "https://github.com/aws/aws-iot-device-sdk-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
