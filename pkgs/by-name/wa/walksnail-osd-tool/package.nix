{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  rustc,
  cmake,
  pkg-config,
  ffmpeg,
  libGL,
  libxkbcommon,
  openssl,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "walksnail-osd-tool";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "avsaase";
    repo = "walksnail-osd-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xCrshFRsM4qUF4TffZiriNaplkjif/LeFOwLxoqtwsY=";
  };

  patches = [ ./make-build-reproducible.patch ];

  cargoPatches = [ ./update-egui.patch ];

  cargoHash = "sha256-AcQasXO4F6XPz/JEwE/Unov3xogXT8vkioy+aNJf7sU=";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    wayland
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    VERGEN_CARGO_TARGET_TRIPLE = stdenv.hostPlatform.rust.rustcTarget;
    VERGEN_RUSTC_SEMVER = rustc.version;
    GIT_VERSION = finalAttrs.version;
    GIT_COMMIT_HASH = finalAttrs.src.rev;
  };

  postInstall = ''
    install -Dm644 resources/icons/app-icon.svg \
      $out/share/icons/hicolor/scalable/apps/${finalAttrs.pname}.svg
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  postFixup = ''
    patchelf $out/bin/.walksnail-osd-tool-wrapped \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "walksnail-osd-tool";
      exec = "walksnail-osd-tool";
      icon = "walksnail-osd-tool";
      comment = "Walksnail OSD Tool";
      desktopName = "Walksnail OSD Tool";
      genericName = "Walksnail OSD Tool";
    })
  ];

  __structuredAttrs = true;

  meta = {
    description = "Renders flight controller OSD and SRT data on Walksnail Avatar HD recordings";
    homepage = "https://github.com/avsaase/walksnail-osd-tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    platforms = lib.platforms.linux;
    mainProgram = "walksnail-osd-tool";
  };
})
