{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gala,
  gsettings-desktop-schemas,
  gtk4,
  glib,
  gnome-settings-daemon,
  granite7,
  libgee,
  mutter,
  pantheon-wayland,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "shortcut-overlay";
    rev = version;
    sha256 = "sha256-oGExG7eWiZqXEPBRuLRTnbgo3hRVKo8vO51vMBPoQb0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gala # org.pantheon.desktop.gala.keybindings
    gsettings-desktop-schemas # org.gnome.desktop.wm.keybindings
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.plugins.media-keys
    granite7
    gtk4
    libgee
    mutter # org.gnome.mutter.keybindings
    pantheon-wayland
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.shortcut-overlay";
  };
}
