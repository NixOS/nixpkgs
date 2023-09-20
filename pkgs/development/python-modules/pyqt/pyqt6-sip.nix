{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyqt6-sip";
  version = "13.5.2";

  src = fetchPypi {
    pname = "PyQt6_sip";
    inherit version;
    hash = "sha256-6/YmS2/toBujfTtgpLuHSTvbh75w97KlOEp6zUkC2I0=";
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
