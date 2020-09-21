{ stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, desktop-file-utils
, pkg-config
, writeScript
, pantheon
, gnome-keyring
, gnome-session
, wingpanel
, orca
, onboard
, at-spi2-core
, elementary-default-settings
, elementary-settings-daemon
, runtimeShell
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
  # them. We then use a xdg autostart and initalize it during the "EarlyInitialization" phase of a gnome session
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
    export XDG_CONFIG_DIRS=${elementary-settings-daemon}/etc/xdg:${elementary-default-settings}/etc:$XDG_CONFIG_DIRS
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS
    exec ${gnome-session}/bin/gnome-session --builtin --session=pantheon "$@"
  '';

  xsession = writeText "pantheon.desktop" ''
    [Desktop Entry]
    Name=Pantheon
    Comment=This session provides elementary experience
    Exec=@out@/libexec/pantheon
    TryExec=${wingpanel}/bin/wingpanel
    Icon=
    DesktopNames=Pantheon
    Type=Application
  '';

in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings-unstable";
  version = "2020-07-06";

  repoName = "session-settings";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "fa15cbd83fba0ba30e9a302db880350bff5ace52";
    hash = "sha256-26H791c7OAjFYtjVChIatICSocMt0uTej1TKBOvw+6w=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    pantheon.elementary-settings-daemon
    gnome-keyring
    onboard
    orca
  ];

  mesonFlags = [
    "-Dmimeapps-list=false"
    "-Dfallback-session=GNOME"
    "-Ddetect-program-prefixes=true"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    cp "${dockitemAutostart}" $out/etc/xdg/autostart/default-elementary-dockitems.desktop

    mkdir -p $out/libexec
    substitute ${executable} $out/libexec/pantheon --subst-var out
    chmod +x $out/libexec/pantheon

    substitute ${xsession} $out/share/xsessions/pantheon.desktop --subst-var out
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };

    providedSessions = [
      "pantheon"
    ];
  };

  meta = with stdenv.lib; {
    description = "Session settings for elementary";
    homepage = "https://github.com/elementary/session-settings";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
