{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "AWSIoTPythonSDK";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-iot-device-sdk-python";
    rev = "v${version}";
    sha256 = "0mbppz1lnia4br5vjz1l4z4vw47y3bzcfpckzhs9lxhj4vq6d001";
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
