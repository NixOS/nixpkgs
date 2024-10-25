{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  evolution-data-server-gtk4,
  libsysprof-capture,
  glib,
  glib-networking,
  gnutls,
  appstream,
  gst_all_1,
  json-glib,
  libadwaita,
  libpeas2,
  libportal-gtk4,
  pipewire,
  libphonenumber,
  libportal,
  pulseaudio,
  vala,
  tracker,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valent";
  version = "1.0.0.alpha.46-unstable-2024-10-05";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "e870cbfd5a1f15e6ac8550500aefe8ea6d2c4539";
    hash = "sha256-qr9wfgt7+mcmni9JrxZAui069cfvyAo38isMbciM1aQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream # appstreamcli
    vala # vapigen
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    glib-networking
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    json-glib
    libadwaita
    libpeas2
    libportal
    libphonenumber
    libportal-gtk4
    tracker
    pipewire
    pulseaudio
    libsysprof-capture
    sqlite
  ]; # optional dependency libwalbottle-0

  mesonFlags = [
    "-Dplugin_bluez=true"
    "-Dvapi=true"
  ];

  meta = {
    description = "Implementation of the KDE Connect protocol, built on GNOME platform libraries";
    mainProgram = "valent";
    longDescription = ''
      Note that you have to open firewall ports for other devices
      to connect to it. Use either:
      ```nix
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      }
      ```
      or open corresponding firewall ports directly:
      ```nix
      networking.firewall = rec {
        allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      }
      ```
    '';
    homepage = "https://valent.andyholmes.ca";
    changelog = "https://github.com/andyholmes/valent/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      cc0
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
