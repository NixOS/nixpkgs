{
  stdenv,
  lib,
  autoreconfHook,
  fetchurl,
  gettext,
  glib,
  gnome-bluetooth,
  gnome-desktop,
  gnome-panel,
  gnome-session,
  gnome,
  gsettings-desktop-schemas,
  gtk3,
  ibus,
  libcanberra-gtk3,
  libpulseaudio,
  libxkbfile,
  libxml2,
  pkg-config,
  polkit,
  gdm,
  systemd,
  upower,
  pam,
  wrapGAppsHook3,
  writeTextFile,
  xkeyboard_config,
  xorg,
  runCommand,
  buildEnv,
}:
let
  pname = "gnome-flashback";
  version = "3.52.1";

  # From data/sessions/Makefile.am
  requiredComponentsCommon = enableGnomePanel: [ ] ++ lib.optional enableGnomePanel "gnome-panel";
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
  requiredComponents =
    wmName: enableGnomePanel:
    "RequiredComponents=${
      lib.concatStringsSep ";" (
        [ wmName ] ++ requiredComponentsCommon enableGnomePanel ++ requiredComponentsGsd
      )
    };";

  gnome-flashback = stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
      hash = "sha256-ugRhPNrbYr2iBkN8BHKZ4WAlzeG9gJXglKp3dpx4YDo=";
    };

    # make .desktop Execs absolute
    postPatch = ''
      patch -p0 <<END_PATCH
      +++ data/applications/gnome-flashback.desktop.in
      @@ -4 +4 @@
      -Exec=gnome-flashback
      +Exec=$out/bin/gnome-flashback
      END_PATCH
    '';

    postInstall = ''
      # Check that our expected RequiredComponents match the stock session files, but then don't install them.
      # They can be installed using mkSessionForWm.
      grep '${requiredComponents "metacity" true}' $out/share/gnome-session/sessions/gnome-flashback-metacity.session || (echo "RequiredComponents have changed, please update gnome-flashback/default.nix."; false)

      rm -r $out/share/gnome-session
      rm -r $out/share/xsessions
      rm $out/libexec/gnome-flashback-metacity
    '';

    nativeBuildInputs = [
      autoreconfHook
      gettext
      libxml2
      pkg-config
      wrapGAppsHook3
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
      xorg.libXxf86vm
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
      updateScript = gnome.updateScript {
        packageName = pname;
        attrPath = "gnome.${pname}";
        versionPolicy = "odd-unstable";
      };

      mkWmApplication =
        {
          wmName,
          wmLabel,
          wmCommand,
        }:
        writeTextFile {
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

      mkGnomeSession =
        {
          wmName,
          wmLabel,
          enableGnomePanel,
        }:
        writeTextFile {
          name = "gnome-flashback-${wmName}-gnome-session";
          destination = "/share/gnome-session/sessions/gnome-flashback-${wmName}.session";
          text = ''
            [GNOME Session]
            Name=GNOME Flashback (${wmLabel})
            ${requiredComponents wmName enableGnomePanel}
          '';
        };

      mkSessionForWm =
        {
          wmName,
          wmLabel,
          wmCommand,
        }:
        writeTextFile {
          name = "gnome-flashback-${wmName}-xsession";
          destination = "/share/xsessions/gnome-flashback-${wmName}.desktop";
          text = ''
            [Desktop Entry]
            Name=GNOME Flashback (${wmLabel})
            Comment=This session logs you into GNOME Flashback with ${wmLabel}
            Exec=${gnome-session}/bin/gnome-session --session=gnome-flashback-${wmName}
            TryExec=${wmCommand}
            Type=Application
            DesktopNames=GNOME-Flashback;GNOME;
          '';
        }
        // {
          providedSessions = [ "gnome-flashback-${wmName}" ];
        };

      mkSystemdTargetForWm =
        {
          wmName,
          wmLabel,
          wmCommand,
          enableGnomePanel,
        }:
        runCommand "gnome-flashback-${wmName}.target" { } ''
          mkdir -p $out/lib/systemd/user
          cp -r "${gnome-flashback}/lib/systemd/user/gnome-session@gnome-flashback-metacity.target.d" \
            "$out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d"
        '';
    };

    meta = with lib; {
      description = "GNOME 2.x-like session for GNOME 3";
      mainProgram = "gnome-flashback";
      homepage = "https://gitlab.gnome.org/GNOME/gnome-flashback";
      license = licenses.gpl2;
      maintainers = teams.gnome.members;
      platforms = platforms.linux;
    };
  };
in
gnome-flashback
