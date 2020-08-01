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
  version = "1.15.2";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "qubole";
    repo = "qds-sdk-py";
    rev = "V${version}";
    sha256 = "0xxg9s0y6fz7vb1kab4q93q7ryi71z8x6q9qspm6s506yr3mc67l";
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
