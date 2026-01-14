{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glycin-loaders,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  vala,
  evolution-data-server-gtk4,
  glib,
  glib-networking,
  gnutls,
  gst_all_1,
  json-glib,
  libadwaita,
  libglycin,
  libpeas2,
  libphonenumber,
  libportal-gtk4,
  pipewire,
  pulseaudio,
  tinysparql,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valent";
  version = "1.0.0.alpha.49";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dVV/rqd3DktI67DPo0qTs3VP7yZIAy7Ew5TSYsE6ZTA=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    vala
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
    libglycin
    libpeas2
    libphonenumber
    libportal-gtk4
    pipewire
    pulseaudio
    tinysparql
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru.updateScript = nix-update-script { };

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
    changelog = "https://github.com/andyholmes/valent/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      cc0
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [
      aleksana
      baduhai
    ];
    platforms = lib.platforms.linux;
  };
})
