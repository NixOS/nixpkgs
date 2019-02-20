{ fetchurl, fetchgit, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, perl, gettext, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, alsaLib, libcanberra-gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libxml2, networkmanager
, docbook_xsl, wrapGAppsHook, python3, ibus, xkeyboard_config, tzdata, nss, pantheon, accountsservice }:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/gnome-settings-daemon-${version}.tar.xz";
    sha256 = "0c663csa3gnsr6wm0xfll6aani45snkdj7zjwjfzcwfh8w4a3z12";
  };

  # Source for ubuntu's patchset
  src2 = fetchgit {
    url = "https://git.launchpad.net/~ubuntu-desktop/ubuntu/+source/gnome-settings-daemon";
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
      inherit tzdata;
    })
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
    for f in $out/etc/xdg/autostart/*; do mv "$f" "''${f%.desktop}-pantheon.desktop"; done

    for autostart in $(grep -rl "OnlyShowIn=GNOME;" $out/etc/xdg/autostart)
    do
      echo "Patching OnlyShowIn to Pantheon in: $autostart"
      sed -i "s,OnlyShowIn=GNOME;,OnlyShowIn=Pantheon;," $autostart
    done

    # This breaks lightlocker https://github.com/elementary/session-settings/commit/b0e7a2867608c3a3916f9e4e21a68264a20e44f8
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

  buildInputs = with gnome3; [
    accountsservice
    alsaLib
    colord
    geoclue2
    geocode-glib
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk
    ibus
    lcms2
    libXtst
    libcanberra-gtk3
    libgudev
    libgweather
    libnotify
    libpulseaudio
    librsvg
    libwacom
    libxkbfile
    networkmanager
    nss
    polkit
    udev
    upower
    xf86_input_wacom
    xkeyboard_config
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
