{ lib, buildPythonPackage, fetchPypi, requests, py, pytest, pytest-flakes }:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30833581d03e07d7574b2ff698d213c984777dd44dd47c45c54d31858c694c94";
  };

  propagatedBuildInputs = [ requests py ];
  checkInputs = [ pytest pytest-flakes ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = https://github.com/devpi/devpi;
    description = "Utilities jointly used by devpi-server and devpi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
