{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  cmake-extras,
  intltool,
  lomiri-content-hub,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  mesa,
  pkg-config,
  poppler,
  qtbase,
  qtdeclarative,
  qtfeedback,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-printing-app";
  version = "0.4.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-printing-app";
    tag = finalAttrs.version;
    hash = "sha256-4iouuiv0FbqNLMJLfKBGoKDX4+/JswdwVtNs77m831k=";
  };

  patches = [
    # Remove when version > 0.4.2
    (fetchpatch {
      name = "0001-lomiri-printing-app-Resize-root-item-to-view.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-printing-app/-/commit/d0fc8241c9ced07ee283022b0e6ce97f6ed2c42c.patch";
      hash = "sha256-3ZSzzvM4FexpbxaLRzVAZVq4xcedM26zHPq2eoNkVwk=";
    })

    # Remove when version > 0.4.2
    (fetchpatch {
      name = "0002-lomiri-printing-app-Allow-PDFs-to-be-shared-to-app.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-printing-app/-/commit/bb9ed1a0476f71fe0f179a1970e572bf65af4e26.patch";
      hash = "sha256-BBf1WMtIHJRSJxZ9SJiWvPEZW7xMIW1P3Oi1Ld9xkmU=";
    })

    # Remove when version > 0.4.2
    (fetchpatch {
      name = "0003-lomiri-printing-app-Config-location.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-printing-app/-/commit/ec22f6145a9f34b5eacadb230c09c7eaaa1c55f2.patch";
      hash = "sha256-aicUWM77ku4n37R3sn7ZTv5ZPGWoj4XeaEOWSxY9kus=";
    })
  ];

  postPatch =
    # Avoid absolute paths in desktop files
    ''
      substituteInPlace lomiri-printing-app/lomiri-printing-app.desktop.in.in \
        --replace-fail '@ICON@' 'lomiri-printing-app'
      substituteInPlace queue-dialog/lomiri-printqueue-dialog.desktop.in.in \
        --replace-fail '@ICON@' 'lomiri-printqueue-dialog'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
    wrapQtAppsHook
  ];

  buildInputs = [
    cmake-extras
    poppler
    qtbase

    # QML
    lomiri-content-hub
    lomiri-ui-extras
    lomiri-ui-toolkit
  ];

  nativeCheckInputs = [
    mesa.llvmpipeHook
    xvfb-run
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "SNAP_MODE" false)
    (lib.cmakeFeature "QT_IMPORTS_DIR" "${placeholder "out"}/${qtbase.qtQmlPrefix}")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Otherwise xvfb-run multiple calls terminate each other
  enableParallelChecking = false;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix [
          lomiri-ui-extras
          lomiri-ui-toolkit
          qtfeedback # propagatedBuildInput of LUITK
        ]
      }
    '';

  postInstall =
    # To allow avoiding of absolute paths in desktop files
    ''
      mkdir -p $out/share/icons/hicolor/scalable/apps

      ln -vs $out/share/lomiri-printing-app/lomiri-printing-app.svg $out/share/icons/hicolor/scalable/apps/lomiri-printing-app.svg
      ln -vs $out/share/lomiri-printing-app/queue-dialog/lomiri-printqueue-dialog.svg $out/share/icons/hicolor/scalable/apps/lomiri-printqueue-dialog.svg
    '';

  passthru = {
    tests.vm = nixosTests.lomiri-printing-app;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Printing app which consumes a PDF from content-hub";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-printing-app";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-printing-app/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-printing-app";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lomiri ];
  };
})
