{ stdenv, fetchurl, cmake, pysideApiextractor, python27Packages, qt4 }:

stdenv.mkDerivation {
  name = "pyside-generatorrunner-0.6.16";

  src = fetchurl {
    url = "https://github.com/PySide/Generatorrunner/archive/0.6.16.tar.gz";
    sha256 = "0vzk3cp0pfbhd921r8f1xkcz96znla39dhj074k623x9k26lj2sj";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pysideApiextractor python27Packages.sphinx qt4 ];

  meta = {
    description = "Eases the development of binding generators for C++ and Qt-based libraries by providing a framework to help automating most of the process";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/generatorrunner/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
