{ lib, buildPythonPackage, fetchFromGitHub, cmake, qt4, pyside, pysideShiboken }:

buildPythonPackage rec {
  pname = "pyside-tools";
  version = "0.2.15";
  format = "other";

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "Tools";
    rev = version;
    sha256 = "017i2yxgjrisaifxqnl3ym8ijl63l2yl6a3474dsqhlyqz2nx2ll";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt4 ];

  propagatedBuildInputs = [ pyside pysideShiboken ];

  meta = with lib; {
    description = "Development tools (pyside-uic/rcc/lupdate) for PySide, the LGPL-licensed Python bindings for the Qt framework";
    license = licenses.gpl2;
    homepage = https://wiki.qt.io/PySide;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
