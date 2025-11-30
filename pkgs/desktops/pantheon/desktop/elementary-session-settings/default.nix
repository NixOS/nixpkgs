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

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-session-settings";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    tag = finalAttrs.version;
    hash = "sha256-mdfmCzR9ikXDlDc7FeOITsdbPbz+G66jUrl1BobY+g8=";
  };

  patches = [
    # See https://github.com/elementary/session-settings/issues/88 for gnome-keyring.
    # See https://github.com/elementary/session-settings/issues/82 for onboard.
    ./no-autostart.patch
  ];

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
})
