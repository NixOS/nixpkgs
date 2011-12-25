{ stdenv, fetchgit, cmake, pysideApiextractor, pysideGeneratorrunner, python27, python27Packages, qt4 }:

stdenv.mkDerivation {
  name = "pyside-shiboken-1.0.7-73-g9f110f8";

  src = fetchgit {
    url = "git://github.com/PySide/Shiboken.git";
    rev = "9f110f83c213867e15b0141a802ebbf74f2ed9f7";
    sha256 = "4618ed113fb20840fd9acb7d08460eb257f630cbca6d61113c16549a6bb651cd";
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
