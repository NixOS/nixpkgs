{ lib
, buildPythonPackage
, fetchPypi
, tox
, pytestCheckHook
, pygame
}:
buildPythonPackage rec {
  pname = "PyRect";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9lFV9t+bkptnyv+9V8CUfFrlRJ07WA0XgHS/+0egm3g=";
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
