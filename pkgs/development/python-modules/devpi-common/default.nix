{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytest
, pytest-flake8
, lazy
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc14aa6b74d4d9e27dc2e9cbff000ed9be5cd723d3ac9672e66e4e8fce797227";
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
