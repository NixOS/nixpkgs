{ lib, fetchFromGitHub, buildPythonPackage
, cmake
, isPy35
, isPy36
, isPy37
, isPy3k
, libxml2
, libxslt
, pkg-config
, pysideApiextractor
, pysideGeneratorrunner
, python
, qt4
, sphinx
}:

buildPythonPackage rec {
  pname = "pyside-shiboken";
  version = "1.2.4";
  format = "other";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "Shiboken";
    rev = version;
    sha256 = "0x2lyg52m6a0vn0665pgd1z1qrydglyfxxcggw6xzngpnngb6v5v";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkg-config pysideApiextractor pysideGeneratorrunner sphinx qt4 ];

  buildInputs = [ python libxml2 libxslt ];

  outputs = [ "out" "dev" ];

  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$dev")
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
