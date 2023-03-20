{ stdenv
, lib
, autoreconfHook
, fetchurl
, gettext
, glib
, gnome-bluetooth
, gnome-desktop
, gnome-panel
, gnome-session
, gnome
, gsettings-desktop-schemas
, gtk3
, ibus
, libcanberra-gtk3
, libpulseaudio
, libxkbfile
, libxml2
, pkg-config
, polkit
, gdm
, systemd
, upower
, pam
, wrapGAppsHook
, writeTextFile
, xkeyboard_config
, xorg
, runCommand
, buildEnv
}:
let
  pname = "gnome-flashback";
  version = "3.46.0";

  # From data/sessions/Makefile.am
  requiredComponentsCommon = enableGnomePanel:
    [ "gnome-flashback" ]
    ++ lib.optional enableGnomePanel "gnome-panel";
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
  requiredComponents = wmName: enableGnomePanel: "RequiredComponents=${lib.concatStringsSep ";" ([ wmName ] ++ requiredComponentsCommon enableGnomePanel ++ requiredComponentsGsd)};";

  gnome-flashback = stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
      sha256 = "sha256-eo1cAzEOTfrdGKZeAKN3QQMq/upUGN1oBKl1xLCYAEU=";
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
      grep '${requiredComponents "metacity" true}' $out/share/gnome-session/sessions/gnome-flashback-metacity.session || (echo "RequiredComponents have changed, please update gnome-flashback/default.nix."; false)

      rm -r $out/share/gnome-session
      rm -r $out/share/xsessions
      rm -r $out/libexec
    '';

    nativeBuildInputs = [
      autoreconfHook
      gettext
      libxml2
      pkg-config
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

      mkSessionForWm = { wmName, wmLabel, wmCommand, enableGnomePanel, panelModulePackages }:
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
              ${requiredComponents wmName enableGnomePanel}
            '';
          };

          # gnome-panel will only look for applets in a single directory so symlink them into here.
          panelModulesEnv = buildEnv {
            name = "gnome-panel-modules-env";
            # We always want to find the built-in panel applets.
            paths = [ gnome-panel gnome-flashback ] ++ panelModulePackages;
            pathsToLink = [ "/lib/gnome-panel/modules" ];
          };

          executable = stdenv.mkDerivation {
            name = "gnome-flashback-${wmName}";
            nativeBuildInputs = [ glib wrapGAppsHook ];
            buildInputs = [ gnome-flashback ] ++ lib.optionals enableGnomePanel ([ gnome-panel ] ++ panelModulePackages);

            # We want to use the wrapGAppsHook mechanism to wrap gnome-session
            # with the environment that gnome-flashback and gnome-panel need to
            # run, including the configured applet packages. This is only possible
            # in the fixup phase, so turn everything else off.
            dontUnpack = true;
            dontConfigure = true;
            dontBuild = true;
            dontInstall = true;
            dontWrapGApps = true; # We want to do the wrapping ourselves.

            # gnome-flashback and gnome-panel need to be added to XDG_DATA_DIRS so that their .desktop files can be found by gnome-session.
            # We need to pass the --builtin flag so that gnome-session invokes gnome-session-binary instead of systemd.
            # If systemd is used, it doesn't use the environment we set up here and so it can't find the .desktop files.
            preFixup = ''
              makeWrapper ${gnome-session}/bin/gnome-session $out \
                --add-flags "--session=gnome-flashback-${wmName} --builtin" \
                --set-default XDG_CURRENT_DESKTOP 'GNOME-Flashback:GNOME' \
                --prefix XDG_DATA_DIRS : '${lib.makeSearchPath "share" ([ wmApplication gnomeSession gnome-flashback ] ++ lib.optional enableGnomePanel gnome-panel)}' \
                "''${gappsWrapperArgs[@]}" \
                ${lib.optionalString enableGnomePanel "--set NIX_GNOME_PANEL_MODULESDIR '${panelModulesEnv}/lib/gnome-panel/modules'"}
            '';
          };

        in
        writeTextFile
          {
            name = "gnome-flashback-${wmName}-xsession";
            destination = "/share/xsessions/gnome-flashback-${wmName}.desktop";
            text = ''
              [Desktop Entry]
              Name=GNOME Flashback (${wmLabel})
              Comment=This session logs you into GNOME Flashback with ${wmLabel}
              Exec=${executable}
              TryExec=${wmCommand}
              Type=Application
              DesktopNames=GNOME-Flashback;GNOME;
            '';
          } // {
          providedSessions = [ "gnome-flashback-${wmName}" ];
        };

      mkSystemdTargetForWm = { wmName, wmLabel, wmCommand, enableGnomePanel }:
        runCommand "gnome-flashback-${wmName}.target" {} ''
          mkdir -p $out/lib/systemd/user
          cp -r "${gnome-flashback}/lib/systemd/user/gnome-session@gnome-flashback-metacity.target.d" \
            "$out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d"
        '';
    };

    meta = with lib; {
      description = "GNOME 2.x-like session for GNOME 3";
      homepage = "https://wiki.gnome.org/Projects/GnomeFlashback";
      license = licenses.gpl2;
      maintainers = teams.gnome.members;
      platforms = platforms.linux;
    };
  };
in
gnome-flashback
