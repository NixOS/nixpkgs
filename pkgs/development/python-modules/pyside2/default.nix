{
  python,
  pythonAtLeast,
  fetchurl,
  lib,
  stdenv,
  cmake,
  libxcrypt,
  ninja,
  qt5,
  shiboken2,
}:
stdenv.mkDerivation rec {
  pname = "pyside2";
  version = "5.15.14";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
    hash = "sha256-MmURlPamt7zkLwTmixQBrSCH5HiaTI8/uGSehhicY3I=";
  };

  patches = [
    ./nix_compile_cflags.patch
    ./Final-details-to-enable-3.12-wheel-compatibility.patch
    ./Python-3.12-Fix-the-structure-of-class-property.patch
    ./Support-running-PySide-on-Python-3.12.patch
    ./shiboken2-clang-Fix-and-simplify-resolveType-helper.patch
    ./shiboken2-clang-Fix-build-with-clang-16.patch
    ./shiboken2-clang-Fix-clashes-between-type-name-and-enumera.patch
    ./shiboken2-clang-Record-scope-resolution-of-arguments-func.patch
    ./shiboken2-clang-Remove-typedef-expansion.patch
    ./shiboken2-clang-Suppress-class-scope-look-up-for-paramete.patch
    ./shiboken2-clang-Write-scope-resolution-for-all-parameters.patch
    ./dont_ignore_optional_modules.patch
    ./Modify-sendCommand-signatures.patch
  ];

  postPatch =
    (lib.optionalString (pythonAtLeast "3.12") ''
      substituteInPlace \
        ez_setup.py \
        build_scripts/main.py \
        build_scripts/options.py \
        build_scripts/utils.py \
        build_scripts/wheel_override.py \
        build_scripts/wheel_utils.py \
        sources/pyside2/CMakeLists.txt \
        --replace-fail "from distutils" "import setuptools; from distutils"
      substituteInPlace \
        build_scripts/config.py \
        build_scripts/main.py \
        build_scripts/options.py \
        build_scripts/setup_runner.py \
        build_scripts/utils.py \
        --replace-fail "import distutils" "import setuptools; import distutils"
    '')
    + ''
      cd sources/pyside2
    '';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DPYTHON_EXECUTABLE=${python.interpreter}"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${qt5.qtdeclarative.dev}/include/QtQuick/${qt5.qtdeclarative.version}/QtQuick";

  nativeBuildInputs = [
    cmake
    ninja
    qt5.qmake
    python
    python.pkgs.setuptools
  ];

  buildInputs =
    (with qt5; [
      qtbase
      qtxmlpatterns
      qtmultimedia
      qttools
      qtx11extras
      qtlocation
      qtscript
      qtwebsockets
      qtwebengine
      qtwebchannel
      qtcharts
      qtsensors
      qtsvg
      qt3d
    ])
    ++ (with python.pkgs; [ setuptools ])
    ++ (lib.optionals (python.pythonOlder "3.9") [
      # see similar issue: 202262
      # libxcrypt is required for crypt.h for building older python modules
      libxcrypt
    ]);

  propagatedBuildInputs = [ shiboken2 ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=pyside2
    cp -r PySide2.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "LGPL-licensed Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
