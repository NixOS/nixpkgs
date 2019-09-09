{ stdenv
, fetchFromGitHub
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
, writeShellScriptBin
, elementary-settings-daemon
, runtimeShell
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
    dock_items="$elementary_default_settings/share/elementary/config/plank/dock1/launchers"/*

    if [ ! -d "$HOME/.config/plank/dock1" ]; then
        echo "Instantiating default Plank Dockitems..."

        mkdir -p $HOME/.config/plank/dock1/launchers
        cp -r --no-preserve=mode,ownership $dock_items $HOME/.config/plank/dock1/launchers/
    else
        echo "Plank Dockitems already instantiated"
    fi
  '';

  dockitemAutostart = substituteAll {
    src = ./default-elementary-dockitems.desktop;
    script = dockitems-script;
  };

  executable = writeShellScriptBin "pantheon" ''
    export XDG_CONFIG_DIRS=${elementary-settings-daemon}/etc/xdg:$XDG_CONFIG_DIRS
    export XDG_DATA_DIRS=${placeholder "out"}/share:$XDG_DATA_DIRS
    exec ${gnome-session}/bin/gnome-session --session=pantheon "$@"
  '';

in

stdenv.mkDerivation rec {
  pname = "elementary-session-settings";
  version = "5.0.3";

  repoName = "session-settings";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1vrjm7bklkfv0dyafm312v4hxzy6lb7p1ny4ijkn48kr719gc71k";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
    };
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    mkdir -p $out/etc/xdg/autostart
    for package in ${gnome-keyring} ${orca} ${onboard} ${at-spi2-core}; do
      cp -av $package/etc/xdg/autostart/* $out/etc/xdg/autostart
    done

    cp "${dockitemAutostart}" $out/etc/xdg/autostart/default-elementary-dockitems.desktop

    mkdir -p $out/share/gnome-session/sessions
    cp -av gnome-session/pantheon.session $out/share/gnome-session/sessions

    mkdir -p $out/share/xsessions
    cp -av xsessions/pantheon.desktop $out/share/xsessions
  '';

  postFixup = ''
    substituteInPlace $out/share/xsessions/pantheon.desktop \
      --replace "gnome-session --session=pantheon" "${executable}/bin/pantheon" \
      --replace "wingpanel" "${wingpanel}/bin/wingpanel"

    for f in $out/etc/xdg/autostart/*; do mv "$f" "''${f%.desktop}-pantheon.desktop"; done

    for autostart in $(grep -rl "OnlyShowIn=GNOME;" $out/etc/xdg/autostart)
    do
      echo "Patching OnlyShowIn to Pantheon in: $autostart"
      sed -i "s,OnlyShowIn=GNOME;,OnlyShowIn=Pantheon;," $autostart
    done
  '';

  meta = with stdenv.lib; {
    description = "Session settings for elementary";
    homepage = https://github.com/elementary/session-settings;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
