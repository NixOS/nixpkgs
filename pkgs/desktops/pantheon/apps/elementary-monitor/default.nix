{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  gettext,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  flatpak,
  glib,
  granite7,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libgtop,
  libX11,
  linuxPackages,
  live-chart,
  pciutils,
  udisks2,
  wingpanel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-monitor";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "monitor";
    tag = finalAttrs.version;
    hash = "sha256-pFyDC22YzThHPElBt/JjFP1A8hoCw9QoIjS2Re8Se9w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libgtop
    libX11
    linuxPackages.nvidia_x11.settings.libXNVCtrl
    live-chart
    pciutils
    udisks2
    wingpanel
  ];

  mesonFlags = [ "-Dindicator-wingpanel=enabled" ];

  postPatch = ''
    # Fix build with Vala 0.56.18
    # https://github.com/elementary/monitor/issues/444
    for i in $(find src/Resources -type f -name "*.vala"); do
      substituteInPlace $i --replace-warn "[Compact]" ""
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage processes and monitor system resources";
    homepage = "https://github.com/elementary/monitor";
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "io.elementary.monitor";
  };
})
