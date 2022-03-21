{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0k6DKkb/Izk15JKrSOC0u5wL3vT4x2CelZt112vc/p0=";
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
