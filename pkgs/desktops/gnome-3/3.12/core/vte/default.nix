{ stdenv, fetchurl, intltool, pkgconfig, gnome3, ncurses, gobjectIntrospection }:

stdenv.mkDerivation rec {

  versionMajor = "0.36";
  versionMinor = "2";
  moduleName   = "vte";
  
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "f45eed3aed823068c7563345ea947be0e6ddb3dacd74646e6d7d26a921e04345";
  };

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib gnome3.gtk3 ncurses ];

  configureFlags = ''--enable-introspection'';

  meta = {
    homepage = http://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK+";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK+, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = "LGPLv2";
    maintainers = with stdenv.lib.maintainers; [ astsmtl antono ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
