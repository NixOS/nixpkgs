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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "3.32.0";

  projectName = "gnome-settings-daemon";

  src = fetchurl {
    url = "mirror://gnome/sources/${projectName}/${stdenv.lib.versions.majorMinor version}/${projectName}-${version}.tar.xz";
    sha256 = "15w3sn9qf1zqlmk8c93kgrh2a20s62m5yfizkp21m5ylrrd07f63";
  };

  # Source for ubuntu's patchset
  src2 = fetchgit {
    url = "https://git.launchpad.net/~ubuntu-desktop/ubuntu/+source/${projectName}";
    rev = "refs/tags/ubuntu/${version}-1ubuntu1";
    sha256 = "0ayd50mr0pv2h4j1r1haf8y2hj8jv59vypa7lx8jis0llrm7s3yn";
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
    "${patchPath}/45_suppress-printer-may-not-be-connected-notification.patch"
    "${patchPath}/64_restore_terminal_keyboard_shortcut_schema.patch"
    "${patchPath}/correct_logout_action.patch"
    "${patchPath}/ubuntu-lid-close-suspend.patch"
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
    for f in $out/etc/xdg/autostart/*; do mv "$f" "''${f%.desktop}-pantheon.desktop"; done

    for autostart in $(grep -rl "OnlyShowIn=GNOME;" $out/etc/xdg/autostart)
    do
      echo "Patching OnlyShowIn to Pantheon in: $autostart"
      sed -i "s,OnlyShowIn=GNOME;,OnlyShowIn=Pantheon;," $autostart
    done

    # This breaks lightlocker https://github.com/elementary/session-settings/commit/b0e7a2867608c3a3916f9e4e21a68264a20e44f8
    # TODO: shouldn't be neeed for the 5.1 greeter (awaiting release)
    rm $out/etc/xdg/autostart/org.gnome.SettingsDaemon.ScreensaverProxy-pantheon.desktop
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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = projectName;
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
