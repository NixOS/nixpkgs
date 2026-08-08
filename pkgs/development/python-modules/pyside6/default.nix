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
  buildPackages,
  pkgsBuildBuild,
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
  ]
  # qtwebview is broken in cross
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    qtwebview
  ];
  qt_linked = symlinkJoin {
    name = "qt_linked";
    paths = packages;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pyside6";

  inherit (shiboken6) version src;

  sourceRoot = "${finalAttrs.src.name}/sources/pyside6";

  # Qt Designer plugin moved to a separate output to reduce closure size
  # for downstream things
  outputs = [
    "out"
    "devtools"
  ];

  # cmake/Macros/PySideModules.cmake supposes that all Qt frameworks on macOS
  # reside in the same directory as QtCore.framework, which is not true for Nix.
  # We therefore symLink all required and optional Qt modules in one directory tree ("qt_linked").
  postPatch = ''
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
    LLVM_INSTALL_DIR = "${lib.getLib llvmPackages.libclang}/lib";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    pythonImportsCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ moveBuildTree ];

  buildInputs = (
    if stdenv.hostPlatform.isLinux then
      # qtwebengine fails under darwin
      # see https://github.com/NixOS/nixpkgs/pull/312987
      packages
      # qtwebengine is broken in cross
      ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
        python.pkgs.qt6.qtwebengine
      ]
    else
      python.pkgs.qt6.darwinVersionInputs
      ++ [
        qt_linked
        cups
      ]
  );

  propagatedBuildInputs = [ shiboken6 ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-Dis_pyside6_superproject_build=1"
    # Needed for cross, similarly to the way the indivudual Qt6 modules are built
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6Quick3DTools_DIR=${pkgsBuildBuild.qt6.qtquick3d}/lib/cmake/Qt6Quick3DTools"
    "-DQt6RemoteObjectsTools_DIR=${pkgsBuildBuild.qt6.qtremoteobjects}/lib/cmake/Qt6RemoteObjectsTools"
    "-DQt6ScxmlTools_DIR=${pkgsBuildBuild.qt6.qtscxml}/lib/cmake/Qt6ScxmlTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    chmod +w .
    python3 setup.py egg_info --build-type=pyside6 --qtpaths=${lib.getExe' buildPackages.python3.pkgs.qt6.qtbase "qtpaths"}
    cp -r PySide6.egg-info $out/${python.sitePackages}/

    mkdir -p "$devtools"
    moveToOutput "${python.pkgs.qt6.qtbase.qtPluginPrefix}/designer" "$devtools"
  '';

  pythonImportsCheck = [ "PySide6" ];

  __structuredAttrs = true;

  meta = {
    description = "Python bindings for Qt";
    license = with lib.licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    changelog = "https://code.qt.io/cgit/pyside/pyside-setup.git/tree/doc/changelogs/changes-${finalAttrs.version}?h=v${finalAttrs.version}";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
