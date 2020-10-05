{ lib,
 fetchFromGitHub,
 buildPythonPackage,
 boto,
 inflection,
 pytest,
 mock,
 requests,
 six,
 urllib3 }:

buildPythonPackage rec {
  pname = "qds_sdk";
  version = "1.16.0";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "qubole";
    repo = "qds-sdk-py";
    rev = "V${version}";
    sha256 = "1hw2bzz9xspzjr7jbvkm8ar58ag0c8x9by6lncydb8v7vxpy20wq";
  };

  propagatedBuildInputs = [
    boto
    inflection
    requests
    six
    urllib3
  ];

  checkInputs = [ pytest mock ];
  checkPhase = ''
    py.test --disable-pytest-warnings tests
  '';

  meta = with lib; {
    description = "A Python module that provides the tools you need to authenticate with, and use the Qubole Data Service API";
    homepage = "https://github.com/qubole/qds-sdk-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 ];
  };
}
