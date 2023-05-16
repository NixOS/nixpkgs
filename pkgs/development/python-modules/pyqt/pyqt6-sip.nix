{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyqt6-sip";
<<<<<<< HEAD
  version = "13.5.2";
=======
  version = "13.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "PyQt6_sip";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-6/YmS2/toBujfTtgpLuHSTvbh75w97KlOEp6zUkC2I0=";
=======
    hash = "sha256-0ekUF1KWZmlXbQSze6CxIqu8QcycNUk3UQKNfZHE3Uk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
