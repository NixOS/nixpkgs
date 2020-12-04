{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bc3709c735ebb3f98f19e96c8887868f4671077d4808076cfc5445912633881";
  };

  propagatedBuildInputs = [ future lxml ];

  # No tests included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
