{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  intltool,
  lomiri-content-hub,
  lomiri-indicator-network,
  lomiri-push-qml,
  lomiri-thumbnailer,
  lomiri-ui-toolkit,
  pkg-config,
  qqc2-suru-style,
  qtbase,
  qtmultimedia,
  qtpositioning,
  qtquickcontrols2,
  quazip,
  quickflux,
  rlottie,
  rlottie-qml,
  tdlib,
  wrapQtAppsHook,
}:

let
  tdlib-1811 = tdlib.overrideAttrs (
    oa: fa: {
      version = "1.8.11";
      src = fetchFromGitHub {
        owner = "tdlib";
        repo = "td";
        rev = "3179d35694a28267a0b6273fc9b5bdce3b6b1235";
        hash = "sha256-XvqqDXaFclWK/XpIxOqAXQ9gcc/dTljl841CN0KrlyA=";
      };

      # CMake 4 compat
      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail 'cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)' 'cmake_minimum_required(VERSION 3.10 FATAL_ERROR)'

        substituteInPlace td/generate/tl-parser/CMakeLists.txt \
          --replace-fail 'cmake_minimum_required(VERSION 3.0 FATAL_ERROR)' 'cmake_minimum_required(VERSION 3.10 FATAL_ERROR)'
      '';
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "teleports";
  version = "1.21";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/teleports";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V9yOQbVXtZGxdiieggPwHd17ilRZ0xMEI2yphgjx188=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/apps/teleports/-/merge_requests/551 merged & in release
    (fetchpatch {
      name = "0001-teleports-Call-i18n.bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/teleports/-/commit/dd537c08453be9bfcdb2ee1eb692514c7e867e41.patch";
      hash = "sha256-zxxFvoj6jluGPCA9GQsxuYYweaSOVrkD01hZwCtq52U=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/teleports/-/merge_requests/586 merged & in release
    ./1001-app-CMakeLists.txt-Drop-explicit-dependency-on-rlottie.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'COMMAND git describe --tags --abbrev=0 --exact-match' 'COMMAND echo v${finalAttrs.version}' \
      --replace-fail 'set(DATA_DIR ''${CMAKE_INSTALL_PREFIX})' 'set(DATA_DIR ''${CMAKE_INSTALL_FULL_DATADIR}/teleports)'

    # Doesn't honour DATA_DIR
    substituteInPlace app/main.cpp push/pushhelper.cpp libs/qtdlib/client/qtdclient.cpp \
      --replace-fail 'QGuiApplication::applicationDirPath()' "QString(\"$out/share/teleports\")"

    substituteInPlace teleports.desktop.in \
      --replace-fail 'assets/icon.svg' 'teleports' \
      --replace-fail 'assets/splash.svg' 'lomiri-app-launch/splash/teleports.svg'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    intltool
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    lomiri-content-hub
    lomiri-indicator-network
    lomiri-push-qml
    lomiri-thumbnailer
    lomiri-ui-toolkit
    rlottie-qml
    qqc2-suru-style
    qtbase
    qtmultimedia
    qtpositioning
    qtquickcontrols2
    quazip
    quickflux
    rlottie
    finalAttrs.passthru.tdlib
  ];

  postInstall = ''
    mkdir -p $out/share/{applications,lomiri-content-hub/peers,icons/hicolor/scalable/apps,lomiri-app-launch/splash,lomiri-url-dispatcher/urls}

    ln -s $out/share/teleports/teleports.desktop $out/share/applications/teleports.desktop
    ln -s $out/share/teleports/teleports.content-hub $out/share/lomiri-content-hub/peers/teleports
    ln -s $out/share/teleports/assets/icon.svg $out/share/icons/hicolor/scalable/apps/teleports.svg
    ln -s $out/share/teleports/assets/splash.svg $out/share/lomiri-app-launch/splash/teleports.svg
    ln -s $out/share/teleports/teleports.url-dispatcher $out/share/lomiri-url-dispatcher/urls/teleports.url-dispatcher
  '';

  passthru = {
    tdlib = tdlib-1811;

    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.vm = nixosTests.teleports;
  };

  meta = {
    description = "Ubuntu Touch Telegram client";
    homepage = "https://gitlab.com/ubports/development/apps/teleports";
    license = with lib.licenses; [
      mit # main
      asl20 # benlau/asyncfuture in qtdlib
      bsd3 # FastScroll.js from Meego? maybe?
      gpl3Only # components
      lgpl3Only # components
    ];
    mainProgram = "teleports";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
