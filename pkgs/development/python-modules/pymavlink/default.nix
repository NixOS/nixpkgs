{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
<<<<<<< HEAD
  version = "2.4.40";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PWpVKtNEof/54MgRNhrJ2LuCAc9qrK1yJNUW+gN8yzA=";
=======
  version = "2.4.37";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dU561/kOBW++mrfzX/kqNVPgi7m/QniBrCJxBD/fZ1Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ future lxml ];

  # No tests included in PyPI tarball. We cannot use the GitHub tarball because
  # we would like to use the same commit of the mavlink messages repo as
  # included in the PyPI tarball, and there is no easy way to determine what
  # commit is included.
  doCheck = false;

  pythonImportsCheck = [ "pymavlink" ];

  meta = with lib; {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    license = with licenses; [ lgpl3Plus mit ];
    maintainers = with maintainers; [ lopsided98 ];
  };
}
