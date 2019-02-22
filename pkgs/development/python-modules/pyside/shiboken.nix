{ lib, fetchurl, cmake, buildPythonPackage, libxml2, libxslt, pysideApiextractor, pysideGeneratorrunner, python, sphinx, qt4, isPy3k, isPy35, isPy36, isPy37 }:

# This derivation provides a Python module and should therefore be called via `python-packages.nix`.
# Python 3.5 is not supported: https://github.com/PySide/Shiboken/issues/77
buildPythonPackage rec {
  pname = "pyside-shiboken";
  version = "1.2.4";

  format = "other";

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

  # gcc6 patch was also sent upstream: https://github.com/pyside/Shiboken/pull/86
  patches = [ ./gcc6.patch ] ++ (lib.optional (isPy35 || isPy36 || isPy37) ./shiboken_py35.patch);

  cmakeFlags = if isPy3k then "-DUSE_PYTHON3=TRUE" else null;

  meta = {
    description = "Plugin (front-end) for pyside-generatorrunner, that generates bindings for C++ libraries using CPython source code";
    license = lib.licenses.gpl2;
    homepage = http://www.pyside.org/docs/shiboken/;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
