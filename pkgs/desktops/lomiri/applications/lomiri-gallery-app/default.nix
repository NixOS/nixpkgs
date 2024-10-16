{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-gallery-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uKGPic9XYUj0rLA05i6GjLM+n17MYgiFJMWnLXHKmIU=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/152 merged & in release
    (fetchpatch {
      name = "0001-lomiri-gallery-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/592eff118cb5056886b73e6698f8941c7a16f2e0.patch";
      hash = "sha256-aR/Lnzvq4RuRLI75mMd4xTGMAcijm1adSAGVFZZ++No=";
    })
    (fetchpatch {
      name = "0002-lomiri-gallery-app-C++ify-i18n.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/a7582abbe0acef4d49c77a4395bc22dbd1707ef3.patch";
      hash = "sha256-qzqTXqIYX+enoOwwV9d9fxe7tVYLuh1WkL8Ij/Qx0H0=";
    })
  ];

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
    tests.vm = nixosTests.lomiri-gallery-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Photo gallery application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    maintainers = lib.teams.lomiri.members;
    mainProgram = "lomiri-gallery-app";
    platforms = lib.platforms.linux;
  };
})
