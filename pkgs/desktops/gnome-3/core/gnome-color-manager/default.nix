{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, gettext
, itstool
, desktop-file-utils
, gnome3
, glib
, gtk3
, colord
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "gnome-color-manager";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nduea2Ry4RmAE4H5CQUzLsHUJYmBchu6gxyiRs6zrTs=";
  };

  patches = [
    # Drop forgotten include
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-color-manager/commit/66aea36411477f284fa8a379b3bde282385d281c.patch";
      sha256 = "m44XfVPGZV9kgm/vIvF9SbsilXNKl2ZwE8SwrhAbU1A=";
    })
  ];

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
    colord
    lcms2
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
