{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytest
, pytest-flake8
, lazy
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O015TOlvFcN7hxwV4SgGmo6vanMuWb+i9KZOYhYZLJM=";
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
