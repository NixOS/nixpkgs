{ stdenv
, autoreconfHook
, fetchurl
, gettext
, glib
, gnome-bluetooth
, gnome-desktop
, gnome-panel
, gnome-session
, gnome3
, gsettings-desktop-schemas
, gtk3
, ibus
, libcanberra-gtk3
, libpulseaudio
, libxkbfile
, libxml2
, pkgconfig
, polkit
, gdm
, systemd
, upower
, pam
, wrapGAppsHook
, writeTextFile
, writeShellScriptBin
, xkeyboard_config
, runCommand
}:
let
  pname = "gnome-flashback";
  version = "3.37.2";

  # From data/sessions/Makefile.am
  requiredComponentsCommon = [
    "gnome-flashback"
    "gnome-panel"
  ];
  requiredComponentsGsd = [
    "org.gnome.SettingsDaemon.A11ySettings"
    "org.gnome.SettingsDaemon.Color"
    "org.gnome.SettingsDaemon.Datetime"
    "org.gnome.SettingsDaemon.Housekeeping"
    "org.gnome.SettingsDaemon.Keyboard"
    "org.gnome.SettingsDaemon.MediaKeys"
    "org.gnome.SettingsDaemon.Power"
    "org.gnome.SettingsDaemon.PrintNotifications"
    "org.gnome.SettingsDaemon.Rfkill"
    "org.gnome.SettingsDaemon.ScreensaverProxy"
    "org.gnome.SettingsDaemon.Sharing"
    "org.gnome.SettingsDaemon.Smartcard"
    "org.gnome.SettingsDaemon.Sound"
    "org.gnome.SettingsDaemon.UsbProtection"
    "org.gnome.SettingsDaemon.Wacom"
    "org.gnome.SettingsDaemon.XSettings"
  ];
  requiredComponents = wmName: "RequiredComponents=${stdenv.lib.concatStringsSep ";" ([ wmName ] ++ requiredComponentsCommon ++ requiredComponentsGsd)};";
  gnome-flashback = stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
      sha256 = "0lz6icgng8ri4sdi3lkdsyvxzfvlkayn85b5346g76vc1w5y03db";
    };

    # make .desktop Execs absolute
    postPatch = ''
      patch -p0 <<END_PATCH
      +++ data/applications/gnome-flashback.desktop.in.in
      @@ -4 +4 @@
      -Exec=gnome-flashback
      +Exec=$out/bin/gnome-flashback
      END_PATCH
    '';

    postInstall = ''
      # Check that our expected RequiredComponents match the stock session files, but then don't install them.
      # They can be installed using mkSessionForWm.
      grep '${requiredComponents "metacity"}' $out/share/gnome-session/sessions/gnome-flashback-metacity.session || (echo "RequiredComponents have changed, please update gnome-flashback/default.nix."; false)

      rm -r $out/share/gnome-session
      rm -r $out/share/xsessions
      rm -r $out/libexec
    '';

    nativeBuildInputs = [
      autoreconfHook
      gettext
      libxml2
      pkgconfig
      wrapGAppsHook
    ];

    buildInputs = [
      glib
      gnome-bluetooth
      gnome-desktop
      gsettings-desktop-schemas
      gtk3
      ibus
      libcanberra-gtk3
      libpulseaudio
      libxkbfile
      polkit
      gdm
      gnome-panel
      systemd
      upower
      pam
      xkeyboard_config
    ];

    doCheck = true;

    enableParallelBuilding = true;

    PKG_CONFIG_LIBGNOME_PANEL_LAYOUTSDIR = "${placeholder "out"}/share/gnome-panel/layouts";
    PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

    passthru = {
      updateScript = gnome3.updateScript {
        packageName = pname;
        attrPath = "gnome3.${pname}";
      };

      mkSessionForWm = { wmName, wmLabel, wmCommand }:
        let
          wmApplication = writeTextFile {
            name = "gnome-flashback-${wmName}-wm";
            destination = "/share/applications/${wmName}.desktop";
            text = ''
              [Desktop Entry]
              Type=Application
              Encoding=UTF-8
              Name=${wmLabel}
              Exec=${wmCommand}
              NoDisplay=true
              X-GNOME-WMName=${wmLabel}
              X-GNOME-Autostart-Phase=WindowManager
              X-GNOME-Provides=windowmanager
              X-GNOME-Autostart-Notify=false
            '';
          };

          gnomeSession = writeTextFile {
            name = "gnome-flashback-${wmName}-gnome-session";
            destination = "/share/gnome-session/sessions/gnome-flashback-${wmName}.session";
            text = ''
              [GNOME Session]
              Name=GNOME Flashback (${wmLabel})
              ${requiredComponents wmName}
            '';
          };

          executable = writeShellScriptBin "gnome-flashback-${wmName}" ''
            if [ -z $XDG_CURRENT_DESKTOP ]; then
              export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
            fi

            export XDG_DATA_DIRS=${wmApplication}/share:${gnomeSession}/share:${gnome-flashback}/share:${gnome-panel}/share:$XDG_DATA_DIRS

            exec ${gnome-session}/bin/gnome-session --session=gnome-flashback-${wmName} "$@"
          '';

        in
        writeTextFile
          {
            name = "gnome-flashback-${wmName}-xsession";
            destination = "/share/xsessions/gnome-flashback-${wmName}.desktop";
            text = ''
              [Desktop Entry]
              Name=GNOME Flashback (${wmLabel})
              Comment=This session logs you into GNOME Flashback with ${wmLabel}
              Exec=${executable}/bin/gnome-flashback-${wmName}
              TryExec=${wmCommand}
              Type=Application
              DesktopNames=GNOME-Flashback;GNOME;
            '';
          } // {
          providedSessions = [ "gnome-flashback-${wmName}" ];
        };

      mkSystemdTargetForWm = { wmName }:
        runCommand "gnome-flashback-${wmName}.target" { } ''
          mkdir -p $out/lib/systemd/user
          cp "${gnome-flashback}/lib/systemd/user/gnome-session-x11@gnome-flashback-metacity.target" \
            "$out/lib/systemd/user/gnome-session-x11@gnome-flashback-${wmName}.target"
        '';
    };

    meta = with stdenv.lib; {
      description = "GNOME 2.x-like session for GNOME 3";
      homepage = "https://wiki.gnome.org/Projects/GnomeFlashback";
      license = licenses.gpl2;
      maintainers = teams.gnome.members;
      platforms = platforms.linux;
    };
  };
in
gnome-flashback
