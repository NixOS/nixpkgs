{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.40";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PWpVKtNEof/54MgRNhrJ2LuCAc9qrK1yJNUW+gN8yzA=";
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
