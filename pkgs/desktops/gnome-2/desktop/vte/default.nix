{ stdenv, fetchurl, intltool, pkgconfig, glib, gtk, ncurses
, pythonSupport ? false, python, pygtk}:

stdenv.mkDerivation rec {
  name = "vte-0.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/0.28/${name}.tar.bz2";
    sha256 = "00zrip28issgmz2cqk5k824cbqpbixi5x7k88zxksdqpnq1f414d";
  };

  patches = [
    ./alt.patch
    # CVE-2012-2738
    ./vte-0.28.2-limit-arguments.patch
  ];

  buildInputs = [ intltool pkgconfig glib gtk ncurses ] ++
                stdenv.lib.optionals pythonSupport [python pygtk];

  configureFlags = ''
    ${if pythonSupport then "--enable-python" else "--disable-python"}
  '';

  postInstall = stdenv.lib.optionalString pythonSupport ''
    cd $(toPythonPath $out)/gtk-2.0
    for n in *; do
      ln -s "gtk-2.0/$n" "../$n"
    done
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
