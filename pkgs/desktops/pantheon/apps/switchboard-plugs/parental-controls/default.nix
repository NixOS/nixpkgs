{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  accountsservice,
  dbus,
  flatpak,
  glib,
  granite7,
  libadwaita,
  libgee,
  malcontent,
  polkit,
  switchboard,
  systemd,
  iptables,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switchboard-plug-parental-controls";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-parental-controls";
    rev = "7b109eb061efff21eb593b4821311148d7d656b7";
    hash = "sha256-bQ8O3kGAebCbHvME6jDdqW0W5GOvxZUuDroZ5b+of2o=";
  };

  patches = [
    # See the nixos/lightdm module for corresponding PAM files.
    # Since we override conffile path we need to create time.conf ourselves.
    ./create-pam-time-conf.patch

    # We cannot really setfacl on read-only desktop files.
    ./disable-applications-tab.patch
  ];

  nativeBuildInputs = [
    gettext
    gtk4 # gtk4-update-icon-cache
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    dbus
    flatpak
    glib
    granite7
    gtk4
    libadwaita
    libgee
    malcontent
    polkit
    switchboard
    systemd
  ];

  mesonFlags = [
    "-Dsharedstatedir=/var/lib"
    "-Dsystemdunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  preFixup = ''
    # For WebRestriction.
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ iptables ]})
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Screen Time & Limits Plug";
    homepage = "https://github.com/elementary/switchboard-plug-parental-controls";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})
