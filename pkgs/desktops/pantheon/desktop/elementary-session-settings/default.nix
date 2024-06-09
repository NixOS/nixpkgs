{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, desktop-file-utils
, pkg-config
, writeScript
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
  common-export = ''
    # gnome-session can find RequiredComponents for `pantheon` session (notably pantheon's patched g-s-d autostarts)
    export XDG_CONFIG_DIRS=@out@/etc/xdg:$XDG_CONFIG_DIRS

    # Make sure we use our gtk-3.0/settings.ini
    export XDG_CONFIG_DIRS=${elementary-default-settings}/etc:$XDG_CONFIG_DIRS

    # * gnome-session can find the `pantheon' session
    # * use pantheon-mimeapps.list
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS
  '';

  executable = writeScript "pantheon" (common-export + ''
    # Start pantheon session. Keep in sync with upstream
    exec ${gnome-session}/bin/gnome-session --session=pantheon "$@"
  '');

  executable-wayland = writeScript "pantheon-wayland" (common-export + ''
    # Start pantheon-wayland session. Keep in sync with upstream
    exec ${gnome-session}/bin/gnome-session --session=pantheon-wayland "$@"
  '');

  # Absolute path patched version of the upstream xsession
  xsession = writeText "pantheon.desktop" ''
    [Desktop Entry]
    Name=Pantheon
    Comment=This session provides elementary experience
    Exec=@out@/libexec/pantheon
    TryExec=${wingpanel}/bin/io.elementary.wingpanel
    Icon=
    DesktopNames=Pantheon
    Type=Application
  '';

  wayland-session = writeText "pantheon-wayland.desktop" ''
    [Desktop Entry]
    Name=Pantheon (Wayland)
    Comment=This session provides elementary experience
    Exec=@out@/libexec/pantheon-wayland
    TryExec=${wingpanel}/bin/io.elementary.wingpanel
    Icon=
    DesktopNames=Pantheon
    Type=Application
  '';
in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  version = "6.0.0-unstable-2024-05-30";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    # For systemd managed gnome-session support.
    # https://github.com/NixOS/nixpkgs/issues/228946
    # nixpkgs-update: no auto update
    rev = "71b7b445189419c34ef24bfbb47709f714055136";
    sha256 = "sha256-Ska64MtyODPtyWkq7PUJnGO/ssegShH6XNuLMVMaFBM=";
  };

  nativeBuildInputs = [
    desktop-file-utils
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

    # script `Exec` to start pantheon
    mkdir -p $out/libexec
    substitute ${executable} $out/libexec/pantheon --subst-var out
    substitute ${executable-wayland} $out/libexec/pantheon-wayland --subst-var out
    chmod +x $out/libexec/pantheon{,-wayland}

    # absolute path patched xsession
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
