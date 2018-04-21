{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python3Packages, ncurses
}:

stdenv.mkDerivation rec {
  name = "libpeas-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0qm908kisyjzjxvygdl18hjqxvvgkq9w0phs2g55pck277sw0bsv";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libpeas"; attrPath = "gnome3.libpeas"; };
  };

  configureFlags = [ "--enable-python3" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =  [ intltool glib gtk3 gnome3.defaultIconTheme ncurses python3Packages.python python3Packages.pygobject3 ];
  propagatedBuildInputs = [
    # Required by libpeas-1.0.pc
    gobjectIntrospection
  ];

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
