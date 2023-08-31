{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyqt5-stubs";
  version = "5.15.6.0";

  src = fetchPypi {
    pname = "PyQt5-stubs";
    inherit version;
    hash = "sha256-kScKwj6/OKHcBM2XqoUs0Ir4Lcg5EA5Tla8UR+Pplwc=";
  };

  meta = with lib; {
    description = "PEP561 stub files for the PyQt5 framework";
    homepage = "https://github.com/python-qt-tools/PyQt5-stubs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mib ];
  };
}
