{ stdenv
, substituteAll
, fetchurl
, fetchgit
, meson
, ninja
, pkgconfig
, gnome3
, perl
, gettext
, gtk3
, glib
, libnotify
, libgnomekbd
, lcms2
, libpulseaudio
, alsaLib
, libcanberra-gtk3
, upower
, colord
, libgweather
, polkit
, gsettings-desktop-schemas
, geoclue2
, systemd
, libgudev
, libwacom
, libxslt
, libxml2
, modemmanager
, networkmanager
, gnome-desktop
, geocode-glib
, docbook_xsl
, accountsservice
, wrapGAppsHook
, python3
, tzdata
, nss
, gcr
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "3.36.0";

  repoName = "gnome-settings-daemon";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/${repoName}-${version}.tar.xz";
    sha256 = "0jddz8f2j4ps7csgq9b694h9hjxsyhlimik6rb2f8nbcxhrg0bzs";
  };

  ubuntuSrc = fetchgit {
    url = "https://git.launchpad.net/~ubuntu-desktop/ubuntu/+source/${repoName}";
    rev = "refs/tags/ubuntu/3.35.91-1ubuntu1";
    sha256 = "1ifrq89pqarx74mkxykvw2kjyljd28i4ggw90l5bk4jjrwfr66f3";
  };

  # We've omitted the 53_sync_input_sources_to_accountsservice patch because it breaks the build.
  # See: https://gist.github.com/worldofpeace/2f152a20b7c47895bb93239fce1c9f52
  #
  # Also omit ubuntu_calculator_snap.patch as that's obviously not useful here.
  patches = let patchPath = "${ubuntuSrc}/debian/patches"; in [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
    "${patchPath}/45_suppress-printer-may-not-be-connected-notification.patch"
    #"${patchPath}/53_sync_input_sources_to_accountsservice.patch"
    "${patchPath}/64_restore_terminal_keyboard_shortcut_schema.patch"
    "${patchPath}/correct_logout_action.patch"
    "${patchPath}/ubuntu-lid-close-suspend.patch"
    "${patchPath}/revert-gsettings-removals.patch"
    "${patchPath}/revert-mediakeys-dbus-interface-drop.patch"
    #"${patchPath}/ubuntu_ibus_configs.patch"
    # https://github.com/elementary/os-patches/blob/6975d1c254cb6ab913b8e2396877203aea8eaa65/debian/patches/elementary-dpms.patch
    ./elementary-dpms.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    perl
    gettext
    libxml2
    libxslt
    docbook_xsl
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    accountsservice
    alsaLib
    colord
    gcr
    geoclue2
    geocode-glib
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk3
    lcms2
    libcanberra-gtk3
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    libgudev
    libgweather
    libnotify
    libpulseaudio
    libwacom
    modemmanager
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
  '';

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
