{ stdenv, fetchurl, cmake, python, pysideGeneratorrunner, pysideShiboken, qt4 }:

stdenv.mkDerivation rec {
  name = "${python.libPrefix}-pyside-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/PySide/PySide/archive/${version}.tar.gz";
    sha256 = "90f2d736e2192ac69e5a2ac798fce2b5f7bf179269daa2ec262986d488c3b0f7";
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
