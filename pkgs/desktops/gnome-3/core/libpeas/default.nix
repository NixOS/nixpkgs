{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python3Packages, ncurses
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

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
