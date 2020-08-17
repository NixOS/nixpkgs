{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6049f270aa0a1013c7dcd32b9f4756d79b6a2ccf73babeca2c46b9e391e644fe";
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
