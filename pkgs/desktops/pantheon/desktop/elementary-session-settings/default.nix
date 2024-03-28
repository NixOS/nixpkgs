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

  #
  # ─── ENSURES PLANK GETS ELEMENTARY'S DEFAULT DOCKITEMS ────────────────────────────
  #

  #
  # Upstream relies on /etc/skel to initiate a new users home directory with plank's dockitems.
  #
  # That is not possible within nixos, but we can achieve this easily with a simple script that copies
  # them. We then use a xdg autostart and initialize it during the "EarlyInitialization" phase of a gnome session
  # which is most appropriate for installing files into $HOME.
  #

  dockitems-script = writeScript "dockitems-script" ''
    #!${runtimeShell}

    elementary_default_settings="${elementary-default-settings}"
    dock_items="$elementary_default_settings/etc/skel/.config/plank/dock1/launchers"/*

    if [ ! -d "$HOME/.config/plank/dock1" ]; then
        echo "Instantiating default Plank Dockitems..."

        mkdir -p "$HOME/.config/plank/dock1/launchers"
        cp -r --no-preserve=mode,ownership $dock_items "$HOME/.config/plank/dock1/launchers/"
    else
        echo "Plank Dockitems already instantiated"
    fi
  '';

  dockitemAutostart = writeText "default-elementary-dockitems.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=Instantiate Default elementary dockitems
    Exec=${dockitems-script}
    StartupNotify=false
    NoDisplay=true
    OnlyShowIn=Pantheon;
    X-GNOME-Autostart-Phase=EarlyInitialization
  '';

  executable = writeScript "pantheon" ''
    # gnome-session can find RequiredComponents for `pantheon` session (notably pantheon's patched g-s-d autostarts)
    export XDG_CONFIG_DIRS=@out@/etc/xdg:$XDG_CONFIG_DIRS

    # Make sure we use our gtk-3.0/settings.ini
    export XDG_CONFIG_DIRS=${elementary-default-settings}/etc:$XDG_CONFIG_DIRS

    # * gnome-session can find the `pantheon' session
    # * use pantheon-mimeapps.list
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS

    # Start pantheon session. Keep in sync with upstream
    exec ${gnome-session}/bin/gnome-session --session=pantheon "$@"
  '';

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

in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  version = "6.0.0-unstable-2023-09-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    # For systemd managed gnome-session support.
    # https://github.com/NixOS/nixpkgs/issues/228946
    # nixpkgs-update: no auto update
    rev = "3476c89bbb66564a72c6495ac0c61f8f9ed7a3ec";
    sha256 = "sha256-Z1qW6m0XDkB92ZZVKx98JOMXiBDbGpQ0cAXgWdqK27c=";
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
  ];

  postInstall = ''
    # our mimeapps patched from upstream to exclude:
    # * evince.desktop -> org.gnome.Evince.desktop
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    # instantiates pantheon's dockitems
    cp "${dockitemAutostart}" $out/etc/xdg/autostart/default-elementary-dockitems.desktop

    # script `Exec` to start pantheon
    mkdir -p $out/libexec
    substitute ${executable} $out/libexec/pantheon --subst-var out
    chmod +x $out/libexec/pantheon

    # absolute path patched xsession
    substitute ${xsession} $out/share/xsessions/pantheon.desktop --subst-var out
  '';

  passthru = {
    updateScript = nix-update-script { };

    providedSessions = [
      "pantheon"
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
