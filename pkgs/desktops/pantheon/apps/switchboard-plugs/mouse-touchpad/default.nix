{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  libgee,
  libxml2,
  granite7,
  gtk4,
  switchboard,
  gettext,
  gnome-settings-daemon,
  glib,
  gala, # needed for gestures support
  touchegg,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-mouse-touchpad";
    tag = version;
    hash = "sha256-Txm6iVwhuqfLrmAVgXeNB0p6PVEenvSSHurMrXoeHoY=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      touchegg = touchegg;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gala
    glib
    granite7
    gtk4
    libgee
    libxml2
    gnome-settings-daemon
    switchboard
    touchegg
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/settings-mouse-touchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
