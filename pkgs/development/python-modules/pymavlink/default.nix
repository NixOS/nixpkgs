{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ppwlsnrvzkpi4fn14d4d4grzx2bmsd0m9369q3f9hw48fgf645";
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
