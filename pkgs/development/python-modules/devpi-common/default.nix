{ lib, buildPythonPackage, fetchPypi, requests, py, pytest }:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2ecae3a92b2da62ecc6586d1c40d265e61bce70d7f1be2327e8b98598ba2687";
  };

  propagatedBuildInputs = [ requests py ];
  checkInputs = [ pytest ];

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
