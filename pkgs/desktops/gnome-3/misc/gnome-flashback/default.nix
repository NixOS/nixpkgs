{ stdenv
, autoreconfHook
, fetchurl
, fetchpatch
, gettext
, glib
, gnome-bluetooth
, gnome-desktop
, gnome-panel
, gnome-session
, gnome3
, gsettings-desktop-schemas
, gtk
, ibus
, intltool
, libcanberra-gtk3
, libpulseaudio
, libxkbfile
, libxml2
, pkgconfig
, polkit
, substituteAll
, upower
, wrapGAppsHook
, writeTextFile
, writeShellScriptBin
, xkeyboard_config
}:

let
  pname = "gnome-flashback";
  version = "3.30.0";
  requiredComponents = wmName: "RequiredComponents=${wmName};gnome-flashback-init;gnome-flashback;gnome-panel;org.gnome.SettingsDaemon.A11ySettings;org.gnome.SettingsDaemon.Clipboard;org.gnome.SettingsDaemon.Color;org.gnome.SettingsDaemon.Datetime;org.gnome.SettingsDaemon.Housekeeping;org.gnome.SettingsDaemon.Keyboard;org.gnome.SettingsDaemon.MediaKeys;org.gnome.SettingsDaemon.Mouse;org.gnome.SettingsDaemon.Power;org.gnome.SettingsDaemon.PrintNotifications;org.gnome.SettingsDaemon.Rfkill;org.gnome.SettingsDaemon.ScreensaverProxy;org.gnome.SettingsDaemon.Sharing;org.gnome.SettingsDaemon.Smartcard;org.gnome.SettingsDaemon.Sound;org.gnome.SettingsDaemon.Wacom;org.gnome.SettingsDaemon.XSettings;";
  gnome-flashback = stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
      sha256 = "18rwql2pi78155l9zp1i50xfi5z8xz2l08m9d81x6qqbfr1nyy57";
    };

    patches =[
      # overrides do not respect gsettingsschemasdir
      # https://gitlab.gnome.org/GNOME/gnome-flashback/issues/9
      (fetchpatch {
       url = https://gitlab.gnome.org/GNOME/gnome-flashback/commit/a55530f58ccd600414a5420b287868ab7d219705.patch;
       sha256 = "1la94lhhb9zlw7bnbpl6hl26zv3kxbsvgx996mhph720wxg426mh";
      })
    ];

    # make .desktop Execs absolute
    postPatch = ''
      patch -p0 <<END_PATCH
      +++ data/applications/gnome-flashback-init.desktop.in
      @@ -4 +4 @@
      -Exec=gnome-flashback --initialize
      +Exec=$out/bin/gnome-flashback --initialize
      +++ data/applications/gnome-flashback.desktop.in
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
      gtk
      ibus
      libcanberra-gtk3
      libpulseaudio
      libxkbfile
      polkit
      upower
      xkeyboard_config
    ];

    doCheck = true;

    enableParallelBuilding = true;

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

      in writeTextFile {
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
      };
    };

    meta = with stdenv.lib; {
      description = "GNOME 2.x-like session for GNOME 3";
      homepage = https://wiki.gnome.org/Projects/GnomeFlashback;
      license = licenses.gpl2;
      maintainers = gnome3.maintainers;
      platforms = platforms.linux;
    };
  };
  in gnome-flashback
