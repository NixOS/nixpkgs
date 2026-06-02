{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  exiv2,
  imagemagick,
  libglvnd,
  libmediainfo,
  lomiri-content-hub,
  lomiri-thumbnailer,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  pkg-config,
  qqc2-suru-style,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-gallery-app";
  version = "3.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-gallery-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5/mZszPEsSZqgioJ+Mc7+0gEcpUKr7n/LgyXJ20P2Zg=";
  };

  postPatch = ''
    # Make splash path in desktop file relative
    substituteInPlace desktop/lomiri-gallery-app.desktop.in.in \
      --replace-fail 'X-Lomiri-Splash-Image=@SPLASH@' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/lomiri-gallery-app.svg'

    # Tried to open videos via 'gio open video://', don't know how this is supposed to be set up yet
    # Just leave it as file:// schema, which resolves fine
    substituteInPlace rc/qml/MediaViewer/SingleMediaViewer.qml \
      --replace-fail '"file://", "video://"' '"file://", "file://"'

    # This makes it harder to see what went wrong in the tests
    substituteInPlace tests/unittests/mediaobjectfactory/CMakeLists.txt \
      --replace-fail ' -xunitxml -o test_mediaobjectfactory.xml' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    imagemagick
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    exiv2
    libglvnd
    libmediainfo
    qtbase
    qtdeclarative
    qtsvg

    # QML
    lomiri-content-hub
    lomiri-thumbnailer
    lomiri-ui-extras
    lomiri-ui-toolkit
    qqc2-suru-style
    qtmultimedia
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "GLVND")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${
        listToQtVar qtbase.qtPluginPrefix [
          qtbase
          qtsvg
        ]
      }
      export XDG_RUNTIME_DIR=$TMP
    '';

  postInstall = ''
    # Link splash to splash dir
    mkdir -p $out/share/lomiri-app-launch/splash
    ln -s $out/share/{lomiri-gallery-app/lomiri-gallery-app-splash.svg,lomiri-app-launch/splash/lomiri-gallery-app.svg}
  '';

  passthru = {
    tests = {
      inherit (nixosTests.lomiri-gallery-app)
        basic
        format-mp4
        format-gif
        format-bmp
        format-jpg
        format-png
        ;
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Photo gallery application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    teams = [ lib.teams.lomiri ];
    mainProgram = "lomiri-gallery-app";
    platforms = lib.platforms.linux;
  };
})
