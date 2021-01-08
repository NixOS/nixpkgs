{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gettext
, itstool
, desktop-file-utils
, gnome3
, glib
, gtk3
, libexif
, libtiff
, colord
, colord-gtk
, libcanberra-gtk3
, lcms2
, vte
, exiv2
}:

stdenv.mkDerivation rec {
  pname = "gnome-color-manager";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fxdng74d8hwhfx1nwl1i4jx9h9f6c2hkyc12f01kqbjcimrxnwx";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    libexif
    libtiff
    colord
    colord-gtk
    libcanberra-gtk3
    lcms2
    vte
    exiv2
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A set of graphical utilities for color management to be used in the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
