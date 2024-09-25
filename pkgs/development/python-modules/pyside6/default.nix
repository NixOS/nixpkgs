{
  lib,
  stdenv,
  cmake,
  cups,
  ninja,
  python,
  pythonImportsCheckHook,
  moveBuildTree,
  shiboken6,
  llvmPackages,
  symlinkJoin,
  libGL,
  darwin,
}:
let
  packages = with python.pkgs.qt6; [
    # required
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
    qtbase

    # optional
    qt3d
    qtcharts
    qtconnectivity
    qtdatavis3d
    qtdeclarative
    qthttpserver
    qtmultimedia
    qtnetworkauth
    qtquick3d
    qtremoteobjects
    qtscxml
    qtsensors
    qtspeech
    qtsvg
    qtwebchannel
    qtwebsockets
    qtpositioning
    qtlocation
    qtshadertools
    qtserialport
    qtserialbus
    qtgraphs
    qttools
  ];
  qt_linked = symlinkJoin {
    name = "qt_linked";
    paths = packages;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pyside6";

  inherit (shiboken6) version src;

  sourceRoot = "pyside-setup-everywhere-src-${finalAttrs.version}/sources/pyside6";

  # cmake/Macros/PySideModules.cmake supposes that all Qt frameworks on macOS
  # reside in the same directory as QtCore.framework, which is not true for Nix.
  # We therefore symLink all required and optional Qt modules in one directory tree ("qt_linked").
  # Also we remove "Designer" from darwin build, due to linking failure
  postPatch =
    ''
      # Don't ignore optional Qt modules
      substituteInPlace cmake/PySideHelpers.cmake \
        --replace-fail \
          'string(FIND "''${_module_dir}" "''${_core_abs_dir}" found_basepath)' \
          'set (found_basepath 0)'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace cmake/PySideHelpers.cmake \
        --replace-fail \
          "Designer" ""
    '';

  # "Couldn't find libclang.dylib You will likely need to add it manually to PATH to ensure the build succeeds."
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LLVM_INSTALL_DIR = "${llvmPackages.libclang.lib}/lib";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python
    pythonImportsCheckHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ moveBuildTree ];

  buildInputs =
    if stdenv.hostPlatform.isLinux then
      # qtwebengine fails under darwin
      # see https://github.com/NixOS/nixpkgs/pull/312987
      packages ++ [ python.pkgs.qt6.qtwebengine ]
    else
      with darwin.apple_sdk_11_0.frameworks;
      [
        qt_linked
        libGL
        cups
        # frameworks
        IOKit
        DiskArbitration
        CoreBluetooth
        EventKit
        AVFoundation
        Contacts
        AGL
        AppKit
      ];

  propagatedBuildInputs = [ shiboken6 ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=pyside6
    cp -r PySide6.egg-info $out/${python.sitePackages}/
  '';

  pythonImportsCheck = [ "PySide6" ];

  meta = {
    description = "Python bindings for Qt";
    license = with lib.licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    changelog = "https://code.qt.io/cgit/pyside/pyside-setup.git/tree/doc/changelogs/changes-${finalAttrs.version}?h=v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ gebner ];
    platforms = lib.platforms.all;
  };
})
