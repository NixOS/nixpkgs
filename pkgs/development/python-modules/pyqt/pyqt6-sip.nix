{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyqt6-sip";
  version = "13.5.1";

  src = fetchPypi {
    pname = "PyQt6_sip";
    inherit version;
    hash = "sha256-0ekUF1KWZmlXbQSze6CxIqu8QcycNUk3UQKNfZHE3Uk=";
  };

  # There is no test code and the check phase fails with:
  # > error: could not create 'PyQt5/sip.cpython-38-x86_64-linux-gnu.so': No such file or directory
  doCheck = false;
  pythonImportsCheck = [ "PyQt6.sip" ];

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage = "https://www.riverbankcomputing.com/software/sip/";
    license = licenses.gpl3Only;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ LunNova ];
  };
}
