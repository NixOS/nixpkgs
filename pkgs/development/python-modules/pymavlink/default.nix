{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "106va20k0ahy0l2qvxf8k5pvqkgdmxbgzd9kij9fkrahlba5mx3v";
  };

  propagatedBuildInputs = [ future lxml ];

  # No tests included in PyPI tarball
  doCheck = false;

  pythonImportsCheck = [ "pymavlink" ];

  meta = with lib; {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
