{ stdenv
, fetchFromGitHub
, fetchpatch
, substituteAll
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
, pkg-config
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
    exec ${gnome-session}/bin/gnome-session --session=pantheon "$@"
  '';

in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  version = "unstable-2019-11-12";

  repoName = "session-settings";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "f9d5afed16ce447cf6ae3c2d1c1db5eece84daca";
    sha256 = "0n1m41aapr58rb1ffvfkjq6c6w3f0ynjzzhja50s4di98p4m7y0q";
  };

  patches = [
    # Map Pantheon required components by g-s-d versions
    # https://github.com/elementary/session-settings/pull/23
    (fetchpatch {
      url = "https://github.com/elementary/session-settings/commit/39918f4ec64fa9ed5affa109d6a692b97ae4ff01.patch";
      sha256 = "0v2kqcsibymnslnnw4v67yh098znsrhrcycgxkw8vymvwlinc502";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    elementary-settings-daemon
  ];

  mesonFlags = [
    "-Ddefaults-list=false"
    "-Dpatched-gsd-autostarts=false"
    "-Dpatched-ubuntu-autostarts=false"
    "-Dfallback-session=GNOME"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    mkdir -p $out/etc/xdg/autostart
    for package in ${gnome-keyring} ${orca} ${onboard} ${at-spi2-core}; do
      cp -av $package/etc/xdg/autostart/* $out/etc/xdg/autostart
    done

    cp "${dockitemAutostart}" $out/etc/xdg/autostart/default-elementary-dockitems.desktop

    mkdir -p $out/libexec
    substitute ${executable} $out/libexec/pantheon --subst-var out
    chmod +x $out/libexec/pantheon
  '';

  postFixup = ''
    substituteInPlace $out/share/xsessions/pantheon.desktop \
      --replace "gnome-session --session=pantheon" "$out/libexec/pantheon" \
      --replace "wingpanel" "${wingpanel}/bin/wingpanel"

    for f in $out/etc/xdg/autostart/*; do mv "$f" "''${f%.desktop}-pantheon.desktop"; done

    for autostart in $(grep -rl "OnlyShowIn=GNOME;" $out/etc/xdg/autostart)
    do
      echo "Patching OnlyShowIn to Pantheon in: $autostart"
      sed -i "s,OnlyShowIn=GNOME;,OnlyShowIn=Pantheon;," $autostart
    done
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
    providedSessions = [ "pantheon" ];
  };

  meta = with stdenv.lib; {
    description = "Session settings for elementary";
    homepage = "https://github.com/elementary/session-settings";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
