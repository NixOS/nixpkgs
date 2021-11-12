{ lib, buildPythonPackage, fetchPypi
, protobuf
, websockets
}:

buildPythonPackage rec {
  pname = "iterm2";
  version = "1.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8245562ed713fd473520f81361cdc1b15835920e1ceb7d588678cd153e77c2b6";
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
    homepage = "https://github.com/gnachman/iTerm2";
    license = licenses.gpl2;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
