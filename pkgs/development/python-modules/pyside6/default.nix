{
  buildPythonPackage,
  python,
  pythonPackages,
  fetchurl,
  lib,
  cmake,
  ninja,
  qt6,
  shiboken6,
  llvmPackages_13,
  callPackage,
}: let
  llvmPackages = llvmPackages_13;
  stdenv = llvmPackages.stdenv;
in
  stdenv.mkDerivation rec {
    pname = "pyside6";
    version = "6.2.2";

    src = fetchurl {
      url = "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
      sha256 = "cKdMfHyeWvRsrlsZQ7w5oTmcQzKzQtLEgQOhz+mYkag=";
    };

    patches = [
      ./dont_ignore_optional_modules.patch
    ];

    postPatch = ''
      cd sources/${pname}
    '';

    CLANG_INSTALL_DIR = llvmPackages.libclang.lib;

    cmakeFlags = [
      "-DBUILD_TESTS=OFF"
    ];

    #QT_LOGGING_RULES = "*.debug=true"; # debug

    #ninjaFlags = [ "-j1" ]; # debug: disable parallel build

    nativeBuildInputs = [cmake ninja python];

    buildInputs =
      (with pythonPackages; [
        packaging
        setuptools
        wheel
        numpy
      ])
      ++ [
        python
        llvmPackages.libclang
        llvmPackages.libllvm
      ];

    propagatedBuildInputs = [
      qt6.qtbase
      shiboken6
    ];

    dontWrapQtApps = true;

    postInstall = ''
      cd ../../..
      python setup.py egg_info --build-type=pyside6
      cp -r PySide6.egg-info $out/${python.sitePackages}/
    '';

    passthru.tests = {
      python-pyside6-hello = (callPackage ./test.nix {}).python-pyside6-hello;
    };

    meta = with lib; {
      description = "LGPL-licensed Python bindings for Qt";
      license = licenses.lgpl21;
      homepage = "https://wiki.qt.io/Qt_for_Python";
      maintainers = with maintainers; [];
    };
  }
