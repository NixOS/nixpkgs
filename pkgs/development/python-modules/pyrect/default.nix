{ lib
, buildPythonPackage
, fetchPypi
, tox
, pytestCheckHook
, pygame
}:
buildPythonPackage rec {
  pname = "PyRect";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Oy+nNTzjKhGqawoVSVlo0qdjQjyJR64ki5LAN9704gI=";
  };

  checkInputs = [ tox pytestCheckHook pygame ];
  pythonImportsCheck = [ "pyrect" ];
  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "Simple module with a Rect class for Pygame-like rectangular areas";
    homepage = "https://github.com/asweigart/pyrect";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
