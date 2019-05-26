{ stdenv
, fetchurl
, glib
, pkgconfig
, perl
, gettext
, gobject-introspection
, gnome3
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "libgtop";
  version = "2.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1m6jbqk8maa52gxrf223442fr5bvvxgb7ham6v039i3r1i62gwvq";
  };

  nativeBuildInputs = [
    pkgconfig
    gtk-doc
    perl
    gettext
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library that reads information about processes and the running system";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
