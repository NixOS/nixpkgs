{
  lib,
  buildPythonPackage,
  fetchPypi,
  mesa,
}:

buildPythonPackage rec {
  pname = "pyqt6-sip";
  version = "13.8.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyQt6_sip";
    inherit version;
    hash = "sha256-L3TPPW2cq1FSvZ9J1XCy37h1U+u1xJGav94n9bn9adQ=";
  };

  # There is no test code and the check phase fails with:
  # > error: could not create 'PyQt5/sip.cpython-38-x86_64-linux-gnu.so': No such file or directory
  doCheck = false;
  pythonImportsCheck = [ "PyQt6.sip" ];

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage = "https://github.com/Python-SIP/sip";
    license = licenses.gpl3Only;
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [ LunNova ];
  };
}
