{ stdenv, fetchurl, cmake, pysideApiextractor, pysideGeneratorrunner, python27, python27Packages, qt4 }:

stdenv.mkDerivation {
  name = "pyside-shiboken-1.2.2";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/pyside/shiboken-1.2.2.tar.bz2";
    sha256 = "1i75ziljl7rgb88nf26hz6cm8jf5kbs9r33b1j8zs4z33z7vn9bn";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pysideApiextractor pysideGeneratorrunner python27 python27Packages.sphinx qt4 ];

  preConfigure = ''
    echo "preConfigure: Fixing shiboken_generator install target."
    substituteInPlace generator/CMakeLists.txt --replace \
      \"$\{GENERATORRUNNER_PLUGIN_DIR}\" lib/generatorrunner/
  '';

  meta = {
    description = "Plugin (front-end) for pyside-generatorrunner, that generates bindings for C++ libraries using CPython source code";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/shiboken/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
