{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytest
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pfl29pnfn120rqv3zwxc22i1hyywwg60rcck9hzxsllbhmfbjqh";
  };

  propagatedBuildInputs = [ requests py ];
  checkInputs = [ pytest pytest-flake8 ];

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
