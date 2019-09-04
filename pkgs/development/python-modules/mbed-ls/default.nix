{ lib, buildPythonPackage, fetchPypi, appdirs, fasteners, prettytable, pytest, mock }:

buildPythonPackage rec {
  pname = "mbed-ls";
  version = "1.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nm4h0d4ijf0vzl10msqg0d3djirsys3j6fl3yda1n9fix3gyrbg";
  };

  checkInputs = [
    mock
    pytest
  ];

  propagatedBuildInputs = [
    appdirs
    fasteners
    prettytable
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # this test requires test_data, which is not present in Pypi
    rm test/platform_detection.py
  '';

  meta = with lib; {
    description = "A Python module that detects and lists mbed-enabled devices connected to the host computer";
    homepage = https://github.com/ARMmbed/mbed-os-tools;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
