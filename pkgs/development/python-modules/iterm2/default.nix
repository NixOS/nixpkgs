{ lib, buildPythonPackage, fetchPypi
, protobuf
, websockets
}:

buildPythonPackage rec {
  pname = "iterm2";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "089pln3c41n6dyh91hw9gy6mpm9s663lpmdc4gamig3g6pfmbsk4";
  };

  propagatedBuildInputs = [ protobuf websockets ];

  # The tests require pyobjc. We can't use pyobjc because at
  # time of writing the pyobjc derivation is disabled on python 3.
  # iterm2 won't build on python 2 because it depends on websockets
  # which is disabled below python 3.3.
  doCheck = false;

  pythonImportsCheck = [ "iterm2" ];

  meta = with lib; {
    description = "Python interface to iTerm2's scripting API";
    homepage = "http://github.com/gnachman/iTerm2";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
