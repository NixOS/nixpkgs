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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchmate";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "azymohliad";
    repo = "watchmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-quEYcJiNPqbQqSfUf8mF2M4bHb7vnW1WzvF5OflubjE=";
  };

  cargoHash = "sha256-k9nvg5wp95OZDYyRLL7s++fJHjO6r+lZtodJLPev988=";

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

  meta = {
    description = "PineTime smart watch companion app for Linux phone and desktop";
    mainProgram = "watchmate";
    homepage = "https://github.com/azymohliad/watchmate";
    changelog = "https://github.com/azymohliad/watchmate/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})
