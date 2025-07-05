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
  elementary-settings-daemon,
  libadwaita,
  libgee,
  gettext,
  gnome-settings-daemon,
  granite7,
  gsettings-desktop-schemas,
  gtk4,
  libxml2,
  libgnomekbd,
  libxklavier,
  ibus,
  onboard,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-keyboard";
    rev = version;
    sha256 = "sha256-8lgoR7nYqUJfLr9UhqnFJWw9x9l97RxgIkAwodHgrzI=";
  };

  patches = [
    # This will try to install packages with apt.
    # https://github.com/elementary/settings-keyboard/issues/324
    ./hide-install-unlisted-engines-button.patch

    (replaceVars ./fix-paths.patch {
      inherit onboard libgnomekbd;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon # io.elementary.settings-daemon.applications
    gnome-settings-daemon # media-keys
    granite7
    gsettings-desktop-schemas
    gtk4
    ibus
    libadwaita
    libgee
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/settings-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
