{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, desktop-file-utils
, gettext
, pkg-config
, gnome-keyring
, gnome-session
, wingpanel
, orca
, onboard
, elementary-default-settings
, gnome-settings-daemon
, runtimeShell
, systemd
, writeText
, meson
, ninja
}:

let
  # Absolute path patched version of the upstream xsession
  xsession = writeText "pantheon.desktop" ''
    [Desktop Entry]
    Name=Pantheon
    Comment=This session provides elementary experience
    Exec=${gnome-session}/bin/gnome-session --session=pantheon
    TryExec=${wingpanel}/bin/io.elementary.wingpanel
    Icon=
    DesktopNames=Pantheon
    Type=Application
  '';

  wayland-session = writeText "pantheon-wayland.desktop" ''
    [Desktop Entry]
    Name=Pantheon (Wayland)
    Comment=This session provides elementary experience
    Exec=${gnome-session}/bin/gnome-session --session=pantheon-wayland
    TryExec=${wingpanel}/bin/io.elementary.wingpanel
    Icon=
    DesktopNames=Pantheon
    Type=Application
  '';
in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    rev = version;
    sha256 = "sha256-4B7lUjHEa4LdKrmsFCB3iFIsdVd/rgwmtQUAgAj3rXs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gnome-keyring
    gnome-settings-daemon
    onboard
    orca
    systemd
  ];

  mesonFlags = [
    "-Dmimeapps-list=false"
    "-Dfallback-session=GNOME"
    "-Ddetect-program-prefixes=true"
    "--sysconfdir=${placeholder "out"}/etc"
    "-Dwayland=true"
  ];

  postInstall = ''
    # our mimeapps patched from upstream to exclude:
    # * evince.desktop -> org.gnome.Evince.desktop
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    # absolute path patched sessions
    substitute ${xsession} $out/share/xsessions/pantheon.desktop --subst-var out
    substitute ${wayland-session} $out/share/wayland-sessions/pantheon-wayland.desktop --subst-var out
  '';

  passthru = {
    updateScript = nix-update-script { };

    providedSessions = [
      "pantheon"
      "pantheon-wayland"
    ];
  };

  meta = with lib; {
    description = "Session settings for elementary";
    homepage = "https://github.com/elementary/session-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
