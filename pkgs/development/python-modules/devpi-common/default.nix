{ lib, buildPythonPackage, fetchPypi, requests, py, pytest, pytest-flakes }:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c7a6471c0f5b07ac9257adec3b3c3a89193ee672fdeb0a6f29487dc9d675e0c";
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
