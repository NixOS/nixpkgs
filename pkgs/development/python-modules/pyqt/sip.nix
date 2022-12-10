{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyqt5-sip";
  version = "12.11.0";

  src = fetchPypi {
    pname = "PyQt5_sip";
    inherit version;
    sha256 = "sha256-tHEP2FtX7e9xbMVfrkW/1b+sb8e6kQNvHcw/Mxyg6zk=";
  };

  # There is no test code and the check phase fails with:
  # > error: could not create 'PyQt5/sip.cpython-38-x86_64-linux-gnu.so': No such file or directory
  doCheck = false;
  pythonImportsCheck = ["PyQt5.sip"];

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "https://www.riverbankcomputing.com/software/sip/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
