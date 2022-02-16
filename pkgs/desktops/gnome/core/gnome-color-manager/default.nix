{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, itstool
, desktop-file-utils
, gnome
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
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nduea2Ry4RmAE4H5CQUzLsHUJYmBchu6gxyiRs6zrTs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "A set of graphical utilities for color management to be used in the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
