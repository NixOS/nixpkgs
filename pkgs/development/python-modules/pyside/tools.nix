{ stdenv, fetchurl, cmake, pyside, python27, qt4, pysideShiboken }:

stdenv.mkDerivation {
  name = "pyside-tools-0.2.15";

  src = fetchurl {
    url = "https://github.com/PySide/Tools/archive/0.2.15.tar.gz";
    sha256 = "0x4z3aq7jgar74gxzwznl3agla9i1dcskw5gh11jnnwwn63ffzwa";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pyside python27 qt4 pysideShiboken ];

  meta = {
    description = "Tools for pyside, the LGPL-licensed Python bindings for the Qt cross-platform application and UI framework";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
