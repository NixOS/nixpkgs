{ stdenv, fetchurl, cmake, pysideGeneratorrunner, pysideShiboken, qt4 }:

stdenv.mkDerivation {
  name = "pyside-1.2.2";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2";
    sha256 = "1qbahpcjwl8d7zvvnc18nxpk1lbifpvjk8pi24ifbvvqcdsdzad1";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pysideGeneratorrunner pysideShiboken qt4 ];

  makeFlags = "QT_PLUGIN_PATH=" + pysideShiboken + "/lib/generatorrunner";

  meta = {
    description = "LGPL-licensed Python bindings for the Qt cross-platform application and UI framework";
    license = stdenv.lib.licenses.lgpl21;
    homepage = "http://www.pyside.org";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
