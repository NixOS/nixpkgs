{ lib, buildPythonPackage, fetchPypi, appdirs, fasteners, prettytable, pytest, mock }:

buildPythonPackage rec {
  pname = "mbed-ls";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nyb3cw4851cs8201q2fkna0z565j7169vj7wm2c88c8fm6qd21i";
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
