{ fetchurl, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, perl, gettext, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, alsaLib, libcanberra-gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libxml2, networkmanager
, docbook_xsl, wrapGAppsHook, python3, ibus, xkeyboard_config, tzdata, nss }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${version}";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0c663csa3gnsr6wm0xfll6aani45snkdj7zjwjfzcwfh8w4a3z12";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig perl gettext libxml2 libxslt docbook_xsl wrapGAppsHook python3 ];

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
