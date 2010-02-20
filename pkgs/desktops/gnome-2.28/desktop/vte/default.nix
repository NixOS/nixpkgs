{ stdenv, fetchurl, intltool, pkgconfig, glib, gtk, ncurses,
  pythonSupport ? false, python}:
stdenv.mkDerivation rec {
  name = "vte-0.22.5";
  src = fetchurl {
    url = "mirror://gnome/desktop/2.28/2.28.2/sources/${name}.tar.bz2";
    sha256 = "1xmjlz79z3apxmq18d5qyliaky6xb1n2nxwvpzrdl4ky6hk73660";
  };
  buildInputs = [ intltool pkgconfig glib gtk ncurses ] ++
                stdenv.lib.optional pythonSupport python;
  configureFlags = ''
    ${if pythonSupport then "--enable-python" else "--disable-python"}
  '';
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
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
