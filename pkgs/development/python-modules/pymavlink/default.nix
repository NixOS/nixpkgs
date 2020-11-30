{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c09e285d049590fd76ef72bc19b4597bef80712e942b3a507ef1521b432d84cd";
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
