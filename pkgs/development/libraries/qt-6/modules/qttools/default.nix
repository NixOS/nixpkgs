{
  pkgsBuildBuild,
  qtModule,
  stdenv,
  lib,
  qtbase,
  qtdeclarative,
  cups,
  llvmPackages_20,
  # clang-based c++ parser for qdoc and lupdate
  withClang ? false,
}:

qtModule {
  pname = "qttools";

  patches = [
    ./paths.patch
  ];

  postPatch = ''
    substituteInPlace \
      src/qdoc/catch/CMakeLists.txt \
      src/qdoc/catch_generators/CMakeLists.txt \
      src/qdoc/catch_conversions/CMakeLists.txt \
      --replace ''\'''${CMAKE_INSTALL_INCLUDEDIR}' "$out/include"
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-DNIX_OUTPUT_OUT=\"${placeholder "out"}\""
  ];

  # FIXME: update to LLVM 21 with Qt 6.10
  buildInputs = lib.optionals withClang [
    llvmPackages_20.libclang
    llvmPackages_20.llvm
  ];

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cups ];

  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6LinguistTools_DIR=${pkgsBuildBuild.qt6.qttools}/lib/cmake/Qt6LinguistTools"
      "-DQt6ToolsTools_DIR=${pkgsBuildBuild.qt6.qttools}/lib/cmake/Qt6ToolsTools"
    ]
    ++ lib.optionals withClang [
      "-DFEATURE_clang=ON"
    ];

  postInstall = ''
    mkdir -p "$dev"
    ln -s "$out/bin" "$dev/bin"
  '';
}
