{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  qtsvg,
  openssl,
  darwin,
  stdenv,
  lib,
  pkgsBuildBuild,
  replaceVars,
  fetchpatch,
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [
    qtbase
    qtlanguageserver
    qtshadertools
    qtsvg
    openssl
  ];
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

  patches = [
    # don't cache bytecode of bare qml files in the store, as that never gets cleaned up
    (replaceVars ./dont-cache-nix-store-paths.patch {
      nixStore = builtins.storeDir;
    })
    # add version specific QML import path
    ./use-versioned-import-path.patch

    # revert codesigning change on Darwin that doesn't work with our signing tools
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/a7084abd9778b955d80e7419e82f6f7b92f7978d.diff";
      hash = "sha256-ESy35OlmsvI4yFQ/rFT8oelOUBCwCmlcbQJvwcTrCig=";
      revert = true;
    })

    # backport fix recommended by KDE
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/8a2c82be6ad90e3f2a0760d8bab1e3a8cdb2473a.diff";
      hash = "sha256-3KbyoQPAiRyCwGnwwYV3y0yz2i6UAJcX70EPsXV0ZZM=";
    })

    # backport required at least for [musescore][1], and perhaps many other
    # applications.
    # [1]: https://github.com/musescore/MuseScore/issues/33015
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/9d4d376726a6ce15c429128dc65b927e411e40da.diff";
      hash = "sha256-XhfliF5wZuN4/E55f8hfipIRjxBe9V7vL1cgn5p4xqA=";
    })

    # backport fix for a QV4 heap corruption crash on JS objects with
    # add/delete/re-add property churn (QTBUG-147153); crashes e.g.
    # quickshell-based shells like noctalia-shell
    # https://bugreports.qt.io/browse/QTBUG-147153
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/624e90bb5e89837d4b759b43e2120b059d98a41e.diff";
      hash = "sha256-7duTYpHZusVNDMlkm19dCppEWBejjTbc0sy3QvJG65s=";
    })
  ];

  cmakeFlags = [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
    # for some reason doesn't get found automatically on Darwin
    "-DPython_EXECUTABLE=${lib.getExe pkgsBuildBuild.python3}"
  ]
  # Conditional is required to prevent infinite recursion during a cross build
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];

  meta.maintainers = with lib.maintainers; [
    nickcao
    outfoxxed
  ];
}
