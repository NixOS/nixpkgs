{ lib, fetchFromGitHub, buildPythonPackage
, cmake
, fetchurl
, isPy3k
, libxml2
, libxslt
, pkg-config
, pysideApiextractor
, pysideGeneratorrunner
, python
, pythonAtLeast
, qt4
, sphinx
}:

buildPythonPackage rec {
  pname = "pyside-shiboken";
  version = "1.2.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "Shiboken";
    rev = version;
    sha256 = "0x2lyg52m6a0vn0665pgd1z1qrydglyfxxcggw6xzngpnngb6v5v";
  };

  nativeBuildInputs = [ cmake pkg-config pysideApiextractor pysideGeneratorrunner sphinx qt4 ];

  buildInputs = [ python libxml2 libxslt ];

  outputs = [ "out" "dev" ];

  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$dev")
    echo "preConfigure: Fixing shiboken_generator install target."
    substituteInPlace generator/CMakeLists.txt --replace \
      \"$\{GENERATORRUNNER_PLUGIN_DIR}\" lib/generatorrunner/
  '';

  patches = [
    # gcc6 patch was also sent upstream: https://github.com/pyside/Shiboken/pull/86
    ./gcc6.patch
    (lib.optional (pythonAtLeast "3.5") ./shiboken_py35.patch)
    (fetchurl {
      # https://github.com/pyside/Shiboken/pull/90
      name = "fix-build-with-python-3.9.patch";
      url = "https://github.com/pyside/Shiboken/commit/d1c901d4c0af581003553865360ba964cda041e8.patch";
      sha256 = "1f7slz8n8rps5r67hz3hi4rr82igc3l166shfy6647ivsb2fnxwy";
    })
  ];

  cmakeFlags = lib.optionals isPy3k [
    "-DUSE_PYTHON3=TRUE"
    "-DPYTHON3_INCLUDE_DIR=${lib.getDev python}/include/${python.libPrefix}"
    "-DPYTHON3_LIBRARY=${lib.getLib python}/lib"
  ];

  meta = with lib; {
    description = "Plugin (front-end) for pyside-generatorrunner, that generates bindings for C++ libraries using CPython source code";
    license = licenses.gpl2;
    homepage = "http://www.pyside.org/";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
