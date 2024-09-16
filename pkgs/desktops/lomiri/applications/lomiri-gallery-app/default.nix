{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  content-hub,
  exiv2,
  imagemagick,
  libglvnd,
  libmediainfo,
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
  version = "3.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-gallery-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nX9dTL4W0WxrwvszGd4AUIx4yUrghMM7ZMtGZLhZE/8=";
  };

  patches = [
    # Remove when version > 3.0.2
    (fetchpatch {
      name = "0001-lomiri-gallery-app-Newer-Evix2-compat.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/afa019b5e9071fbafaa9afb3b4effdae6e0774c5.patch";
      hash = "sha256-gBc++6EQ7t3VcBZTknkIpC0bJ/P15oI+G0YoQWtjnSY=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/147 merged & in release
    (fetchpatch {
      name = "0002-lomiri-gallery-app-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/0149c8d422c3e0889d7d523789dc65776a52c4f9.patch";
      hash = "sha256-jS81F7KNbAn5J8sDDXzhXARNYAu6dEKcbNHpHp/3MaI=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/148 merged & in release
    (fetchpatch {
      name = "0003-lomiri-gallery-app-Fix-GNUInstallDirs.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/805121b362a9b486094e570053884b9ffa92b152.patch";
      hash = "sha256-fyAqKjZ0g7Sw7fWP1IW4SpZ+g0xi/pH6RJie1K3doP0=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/149 merged & in release
    (fetchpatch {
      name = "0004-lomiri-gallery-app-Fix-icons.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/906966536363e80fe9906dee935d991955e8f842.patch";
      hash = "sha256-LJ+ILhokceXFUvP/G1BEBE/J1/XUAmNBxu551x0Q6nk=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/150 merged & in release
    (fetchpatch {
      name = "0005-lomiri-gallery-app-Add-ENABLE_WERROR.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/fe32a3453b88cc3563e53ab124f669ce307e9688.patch";
      hash = "sha256-nFCtY3857D5e66rIME+lj6x4exEfx9D2XGEgyWhemgI=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/151 merged & in release
    (fetchpatch {
      name = "0006-lomiri-gallery-app-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/51f3d5e643db5576b051da63c58ba3492c851e44.patch";
      hash = "sha256-5aGx2xfCDgq/khgkzGsvUOmTIYALjyfn6W7IR5dldr8=";
    })
    (fetchpatch {
      name = "0007-lomiri-gallery-app-Top-level-Qt5Test.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/c308c689c2841d71554ff6397a110d1a12016b70.patch";
      hash = "sha256-fXVOKjnj4EPeby9iEp3mZRqx9MLqdF8SUVEouCkyDRc=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/152 merged & in release
    (fetchpatch {
      name = "0008-lomiri-gallery-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/commit/90a79972741ee0c5dc734dba6c42afeb3ee6a699.patch";
      hash = "sha256-YAmH0he5/rZYKWFyPzUFAKJuHhUTxB3q8zbLL7Spz/c=";
    })
  ];

  postPatch = ''
    # 0003-lomiri-gallery-app-Fix-icons.patch cannot be fully applied via patches due to binary diffs
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-gallery-app/-/merge_requests/149 merged & in release
    for size in 64x64 128x128 256x256; do
      rm desktop/icons/hicolor/"$size"/apps/gallery-app.png
      magick desktop/lomiri-gallery-app.svg -resize "$size" desktop/icons/hicolor/"$size"/apps/lomiri-gallery-app.png
    done

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
    content-hub
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

    # Old name
    mv $out/share/content-hub/peers/{,lomiri-}gallery-app
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
