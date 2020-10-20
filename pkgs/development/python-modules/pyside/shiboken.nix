{ lib, fetchurl, buildPythonPackage
, cmake
, libxml2
, pkg-config
, libxslt
, pysideApiextractor
, pysideGeneratorrunner
, python
, sphinx
, qt4
, isPy3k
, isPy35
, isPy36
, isPy37
}:

buildPythonPackage rec {
  pname = "pyside-shiboken";
  version = "1.2.4";
  disabled = !isPy3k;

  format = "other";

  src = fetchurl {
    url = "https://github.com/PySide/Shiboken/archive/${version}.tar.gz";
    sha256 = "1536f73a3353296d97a25e24f9554edf3e6a48126886f8d21282c3645ecb96a4";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkg-config pysideApiextractor pysideGeneratorrunner sphinx qt4 ];

  buildInputs = [ python libxml2 libxslt ];

  preConfigure = ''
    echo "preConfigure: Fixing shiboken_generator install target."
    substituteInPlace generator/CMakeLists.txt --replace \
      \"$\{GENERATORRUNNER_PLUGIN_DIR}\" lib/generatorrunner/
  '';

  # gcc6 patch was also sent upstream: https://github.com/pyside/Shiboken/pull/86
  patches = [ ./gcc6.patch ] ++ (lib.optional (isPy35 || isPy36 || isPy37) ./shiboken_py35.patch);

  cmakeFlags = lib.optionals isPy3k [
    "-DUSE_PYTHON3=TRUE"
    "-DPYTHON3_INCLUDE_DIR=${lib.getDev python}/include/${python.libPrefix}"
    "-DPYTHON3_LIBRARY=${lib.getLib python}/lib"
  ];

  meta = {
    description = "Plugin (front-end) for pyside-generatorrunner, that generates bindings for C++ libraries using CPython source code";
    license = lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/shiboken/";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
