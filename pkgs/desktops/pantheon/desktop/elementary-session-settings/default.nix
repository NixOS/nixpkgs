{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  gettext,
  pkg-config,
  gnome-keyring,
  gnome-session,
  wingpanel,
  orca,
  onboard,
  elementary-default-settings,
  gnome-settings-daemon,
  runtimeShell,
  systemd,
  writeText,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  # Allow disabling x11 session
  # nixpkgs-update: no auto update
  version = "8.0.1-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    rev = "e708fd49356f145acd926d30683012d9488f0f9d";
    hash = "sha256-wb9UUrEtwtmqtfNS2YPli99ZeY17UdJFQijTKs8mHn4=";
  };

  /*
    This allows `elementary-session-settings` to not use gnome-keyring's ssh capabilities anymore, as they have been
    moved to gcr upstream, in an effort to modularize gnome-keyring.

    More info can be found here: https://gitlab.gnome.org/GNOME/gnome-keyring/-/merge_requests/60
  */
  patches = [ ./no-gnome-keyring-ssh-autostart.patch ];

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
    "-Ddetect-program-prefixes=true"
    # https://github.com/elementary/session-settings/issues/91
    "-Dx11=false"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    # our mimeapps patched from upstream to exclude:
    # * evince.desktop -> org.gnome.Evince.desktop
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    # absolute path patched sessions
    substituteInPlace $out/share/wayland-sessions/pantheon-wayland.desktop \
      --replace-fail "Exec=gnome-session" "Exec=${gnome-session}/bin/gnome-session" \
      --replace-fail "TryExec=io.elementary.wingpanel" "TryExec=${wingpanel}/bin/io.elementary.wingpanel"
  '';

  passthru = {
    updateScript = nix-update-script { };

    providedSessions = [
      "pantheon-wayland"
    ];
  };

  meta = with lib; {
    description = "Session settings for elementary";
    homepage = "https://github.com/elementary/session-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
