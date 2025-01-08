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
    substituteInPlace $out/share/{xsessions/pantheon.desktop,wayland-sessions/pantheon-wayland.desktop} \
      --replace-fail "Exec=gnome-session" "Exec=${gnome-session}/bin/gnome-session" \
      --replace-fail "TryExec=io.elementary.wingpanel" "TryExec=${wingpanel}/bin/io.elementary.wingpanel"
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
