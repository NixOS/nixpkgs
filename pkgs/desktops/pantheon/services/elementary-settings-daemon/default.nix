{ accountsservice
, alsaLib
, colord
, docbook_xsl
, fetchgit
, fetchurl
, geoclue2
, geocode-glib
, gettext
, glib
, gnome3
, gsettings-desktop-schemas
, gtk3
, lcms2
, libcanberra-gtk3
, libgnomekbd
, libgudev
, libgweather
, libnotify
, libpulseaudio
, libwacom
, libxml2
, libxslt
, meson
, mousetweaks
, networkmanager
, ninja
, nss
, pantheon
, perl
, pkgconfig
, polkit
, python3
, stdenv
, substituteAll
, systemd
, tzdata
, upower
, libXtst
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "3.30.2";

  repoName = "gnome-settings-daemon";

  src = fetchurl {
    url = "mirror://gnome/sources/${repoName}/${stdenv.lib.versions.majorMinor version}/${repoName}-${version}.tar.xz";
    sha256 = "0c663csa3gnsr6wm0xfll6aani45snkdj7zjwjfzcwfh8w4a3z12";
  };

  # Source for ubuntu's patchset
  src2 = fetchgit {
    url = "https://git.launchpad.net/~ubuntu-desktop/ubuntu/+source/${repoName}";
    rev = "refs/tags/ubuntu/${version}-1ubuntu1";
    sha256 = "02awkhw6jqm7yh812mw0nsdmsljfi8ksz8mvd2qpns5pcv002g2c";
  };

  # We've omitted the 53_sync_input_sources_to_accountsservice patch because it breaks the build.
  # See: https://gist.github.com/worldofpeace/2f152a20b7c47895bb93239fce1c9f52
  #
  # Also omit ubuntu_calculator_snap.patch as that's obviously not useful here.
  patches = let patchPath = "${src2}/debian/patches"; in [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata mousetweaks;
    })
    ./global-backlight-helper.patch
    "${patchPath}/45_suppress-printer-may-not-be-connected-notification.patch"
    "${patchPath}/64_restore_terminal_keyboard_shortcut_schema.patch"
    "${patchPath}/correct_logout_action.patch"
    "${patchPath}/ubuntu-lid-close-suspend.patch"
    "${patchPath}/revert-wacom-migration.patch"
    "${patchPath}/revert-gsettings-removals.patch"
    "${patchPath}/revert-mediakeys-dbus-interface-drop.patch"
    "${patchPath}/ubuntu_ibus_configs.patch"
    (fetchurl {
      url = "https://github.com/elementary/os-patches/raw/6975d1c254cb6ab913b8e2396877203aea8eaa65/debian/patches/elementary-dpms.patch";
      sha256 = "0kh508ppiv4nvkg30gmw85cljlfq1bvkzhvf1iaxw0snb0mwgsxi";
    })
  ];

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  postFixup = ''
    for autostart in $(grep -rl "OnlyShowIn=GNOME;" $out/etc/xdg/autostart)
    do
      echo "Patching OnlyShowIn to Pantheon in: $autostart"
      sed -i "s,OnlyShowIn=GNOME;,OnlyShowIn=Pantheon;," $autostart
    done

    # This breaks lightlocker https://github.com/elementary/session-settings/commit/b0e7a2867608c3a3916f9e4e21a68264a20e44f8
    # TODO: shouldn't be neeed for the 5.1 greeter (awaiting release)
    rm $out/etc/xdg/autostart/org.gnome.SettingsDaemon.ScreensaverProxy.desktop

    # So the polkit policy can reference /run/current-system/sw/bin/elementary-settings-daemon/gsd-backlight-helper
    mkdir -p $out/bin/elementary-settings-daemon
    ln -s $out/libexec/gsd-backlight-helper $out/bin/elementary-settings-daemon/gsd-backlight-helper
  '';

  nativeBuildInputs = [
    docbook_xsl
    gettext
    libxml2
    libxslt
    meson
    ninja
    perl
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    alsaLib
    colord
    geoclue2
    geocode-glib
    glib
    gnome3.gnome-desktop
    gsettings-desktop-schemas
    gtk3
    lcms2
    libXtst
    libcanberra-gtk3
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    libgudev
    libgweather
    libnotify
    libpulseaudio
    libwacom
    networkmanager
    nss
    polkit
    systemd
    upower
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

    # Default for release buildtype but passed manually because
    # we're using plain
  NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = repoName;
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
