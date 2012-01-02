{ stdenv, fetchgit, cmake, pysideGeneratorrunner, pysideShiboken, qt4 }:

stdenv.mkDerivation {
  name = "pyside-1.0.9";

  src = fetchgit {
    url = "git://github.com/PySide/PySide.git";
    rev = "4e47b3284fd8715b68342e755cd06ba02b1df0de";
    sha256 = "1fd302e78c5dea8a9c312bd493c04240f2383517ee745d9df2b070f15f0ab515";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pysideGeneratorrunner pysideShiboken qt4 ];

  makeFlags = "QT_PLUGIN_PATH=" + pysideShiboken + "/lib/generatorrunner";

  meta = {
    description = "LGPL-licensed Python bindings for the Qt cross-platform application and UI framework.";
    license = stdenv.lib.licenses.lgpl21;
    homepage = "http://www.pyside.org";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
