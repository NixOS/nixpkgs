{ fetchurl, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, perl, gettext, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, alsaLib, libcanberra-gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libxml2, networkmanager
, docbook_xsl, wrapGAppsHook, ibus, xkeyboard_config, tzdata, nss }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0z9dip9p0iav646cmxisii5sbkdr9hmaklc5fzvschpbjkhphksr";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja pkgconfig perl gettext libxml2 libxslt docbook_xsl wrapGAppsHook ];

  buildInputs = with gnome3; [
    ibus gtk glib gsettings-desktop-schemas networkmanager
    libnotify gnome-desktop lcms2 libXtst libxkbfile libpulseaudio alsaLib
    libcanberra-gtk3 upower colord libgweather xkeyboard_config nss
    polkit geocode-glib geoclue2 librsvg xf86_input_wacom udev libgudev libwacom
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-settings-daemon";
      attrPath = "gnome3.gnome-settings-daemon";
    };
  };

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
