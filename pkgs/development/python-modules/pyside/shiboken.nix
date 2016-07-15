{ stdenv, fetchurl, cmake, libxml2, libxslt, pysideApiextractor, pysideGeneratorrunner, python, sphinx, qt4, isPy3k, isPy35 }:

# Python 3.5 is not supported: https://github.com/PySide/Shiboken/issues/77
stdenv.mkDerivation rec {
  name = "${python.libPrefix}-pyside-shiboken-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/PySide/Shiboken/archive/${version}.tar.gz";
    sha256 = "1536f73a3353296d97a25e24f9554edf3e6a48126886f8d21282c3645ecb96a4";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake libxml2 libxslt pysideApiextractor pysideGeneratorrunner python sphinx qt4 ];

  preConfigure = ''
    echo "preConfigure: Fixing shiboken_generator install target."
    substituteInPlace generator/CMakeLists.txt --replace \
      \"$\{GENERATORRUNNER_PLUGIN_DIR}\" lib/generatorrunner/
  '';
  patches = if isPy35 then [ ./shiboken_py35.patch ] else null;

  cmakeFlags = if isPy3k then "-DUSE_PYTHON3=TRUE" else null;

  meta = {
    description = "Plugin (front-end) for pyside-generatorrunner, that generates bindings for C++ libraries using CPython source code";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/shiboken/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
