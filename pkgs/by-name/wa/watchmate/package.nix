{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  libadwaita,
  bluez,
  dbus,
  openssl,
  wrapGAppsHook4,
  glib,
}:
let
  releaseVersion = "0.5.2";
in
rustPlatform.buildRustPackage rec {
  pname = "watchmate";
  version = "${releaseVersion}-unstable-2024-08-13";

  src = fetchFromGitHub {
    owner = "azymohliad";
    repo = "watchmate";
    rev = "e05edfae94a1973110c6f40f25133d5979f485ab";
    hash = "sha256-fHWxn7hFx/9cnLlCHIC6hIJaLd1U3Ii9mJgTJ+Hw63M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mpris2-zbus-0.1.0" = "sha256-a/cvbB0M9cUd8RP5XxgHRbJ/i/UKAEK4DTwwUU69IuY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    gtk4
    libadwaita
    bluez
    dbus
    openssl
  ];

  postInstall = ''
    install -Dm444 assets/io.gitlab.azymohliad.WatchMate.desktop -t $out/share/applications/
    install -Dm444 assets/io.gitlab.azymohliad.WatchMate.metainfo.xml -t $out/share/metainfo/
    install -Dm444 assets/io.gitlab.azymohliad.WatchMate.gschema.xml -t $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas/
    install -Dm444 assets/icons/io.gitlab.azymohliad.WatchMate.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 assets/icons/io.gitlab.azymohliad.WatchMate-symbolic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  meta = with lib; {
    description = "PineTime smart watch companion app for Linux phone and desktop";
    mainProgram = "watchmate";
    homepage = "https://github.com/azymohliad/watchmate";
    changelog = "https://github.com/azymohliad/watchmate/raw/v${releaseVersion}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
