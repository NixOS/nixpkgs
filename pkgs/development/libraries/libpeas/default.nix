{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobject-introspection, python3, ncurses
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qm908kisyjzjxvygdl18hjqxvvgkq9w0phs2g55pck277sw0bsv";
  };

  configureFlags = [ "--enable-python3" ];

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];
  buildInputs =  [ glib gtk3 ncurses python3 python3.pkgs.pygobject3 ];
  propagatedBuildInputs = [
    # Required by libpeas-1.0.pc
    gobject-introspection
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = https://wiki.gnome.org/Projects/Libpeas;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
