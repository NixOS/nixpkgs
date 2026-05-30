{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
    tag = finalAttrs.version;
    hash = "sha256-yxQZSbbtWP0+gMu4cZt4bKZC7z8iZILAILYnn9ExnJY=";
  };

  patches = [
    # Change default config file path and separate default and run-time config file
    # https://github.com/elementary/switchboard-plug-parental-controls/pull/206
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-parental-controls/commit/1e5a08c1c3b0a5503e9d3f6858047d53ed8188f7.patch";
      hash = "sha256-daP/nBmrUw8b3UytIZz3bKdM+lIgAIQ/DJP0h9sdXmc=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-parental-controls/commit/51f027657616a5d4a6bd24478a5b94fad12edb95.patch";
      hash = "sha256-JOogF1ychF7MAJdrKT4eiUgM8+Y7CN9nxnRNidRoMOk=";
    })

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
    # For /var/lib/pantheon-parental-controls/daemon.conf
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
