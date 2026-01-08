{
  qtModule,
  qtdeclarative,
  qtbase,
  qttools,
  pkgsBuildBuild,
  stdenv,
  lib,
}:

let
  isCrossBuild = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  # Docs are architecture-independent; when cross-compiling, prefer using build-machine
  # Qt tooling + Qt installation to avoid mixing target+build qtbase setup hooks.
  qtbaseForDocs = if isCrossBuild then pkgsBuildBuild.qt6.qtbase else qtbase;
  qttoolsForDocs = if isCrossBuild then pkgsBuildBuild.qt6.qttools else qttools;
  qttoolsForDocsWithClang = qttoolsForDocs.override { withClang = true; };
  # Qt's build internals expect QT_HOST_PATH to be a single prefix containing host tools
  # (qdoc, qhelpgenerator, qtattributionsscanner, ...) and CMake package configs.
  # In Nix, those live in separate store paths (qtbase vs qttools), so we synthesize
  # a minimal merged prefix for cross builds.
  qtHostPath =
    if isCrossBuild then
      pkgsBuildBuild.runCommand "qt6-host-path-for-qtdoc" { } ''
        mkdir -p "$out/bin" "$out/lib/cmake" "$out/libexec"

        # Host tool executables come from qttools.
        for f in ${qttoolsForDocsWithClang}/bin/*; do
          ln -s "$f" "$out/bin/$(basename "$f")"
        done
        for f in ${qttoolsForDocsWithClang}/libexec/*; do
          ln -s "$f" "$out/libexec/$(basename "$f")"
        done

        # CMake package configs come from qtbase (+ qttools for tool packages).
        for d in ${qtbaseForDocs}/lib/cmake ${qttoolsForDocsWithClang}/lib/cmake; do
          if [ -d "$d" ]; then
            for p in "$d"/*; do
              # IMPORTANT: don't follow an existing symlink-to-dir (e.g. Qt6), or we'd
              # accidentally try to create links inside the read-only store path.
              ln -sfnT "$p" "$out/lib/cmake/$(basename "$p")"
            done
          fi
        done
      ''
    else
      null;
in
qtModule {
  pname = "qtdoc";
  # avoid fix-qt-builtin-paths hook substitute QT_INSTALL_DOCS to qtdoc's path
  postPatch = ''
    for file in $(grep -rl '$QT_INSTALL_DOCS' . || true); do
      substituteInPlace $file \
          --replace '$QT_INSTALL_DOCS' "${qtbaseForDocs}/share/doc"
    done
  '';
  # When cross-compiling, the doc generator (`qdoc`) is a *build-machine* tool.
  # If we use the target `qttools` here, it pulls in target LLVM/clang and fails
  # early (e.g. MinGW LLVM dylib export table limits).
  nativeBuildInputs = [

    qttoolsForDocsWithClang

  ];
  # Avoid pulling target Qt modules into the build environment when cross-compiling,
  # which would mix host/build qtbase setup hooks.
  propagatedBuildInputs = lib.optionals (!isCrossBuild) [ qtdeclarative ];

  cmakeFlags = lib.optionals isCrossBuild [
    # qtbase requires an explicit QT_HOST_PATH when cross-compiling via qt_build_repo_begin()
    # (see MSYS2 `qt6-doc` which passes `-DQT_HOST_PATH=...`).
    "-DQT_HOST_PATH=${qtHostPath}"
    "-DQt6HostInfo_DIR=${qtHostPath}/lib/cmake/Qt6HostInfo"
  ];

  env = lib.optionalAttrs isCrossBuild {
    # Qt's docs helpers export QT_INSTALL_DOCS into the qdoc invocation. If unset,
    # it defaults to a non-existent `${qtbase}/doc` path in our split installs.
    # Provide a real directory so qdoc doesn't fail with "no such file or directory".
    QT_INSTALL_DOCS = "${qtbaseForDocs}/share/doc";
  };

  # qtbase's docs CMake expects a response file at `${BUILDDIR}/.doc/Release/includes.txt`
  # (passed to qdoc as `@.../includes.txt`). In our cross setup this file is not created
  # early enough (or at all), and qdoc fails with a generic "no such file or directory".
  # Create placeholder response files for the doc sub-builds.
  postConfigure = lib.optionalString isCrossBuild ''
    mkdir -p build/doc/.doc/Release
    : > build/doc/.doc/Release/includes.txt

    if [ -d build/doc/src ]; then
      for d in build/doc/src/*; do
        [ -d "$d" ] || continue
        mkdir -p "$d/.doc/Release"
        : > "$d/.doc/Release/includes.txt"
      done
    fi
  '';

  ninjaFlags = [ "docs" ];
  installTargets = [ "install_docs" ];
}
