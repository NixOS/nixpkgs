{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytest
, pytest-flake8
, lazy
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f1eb1bf85a5dabd4f4ecc11ad99588e01cc204989a9f424c2dbe5809c6c3745";
  };

  propagatedBuildInputs = [
    requests
    py
    lazy
  ];
  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
