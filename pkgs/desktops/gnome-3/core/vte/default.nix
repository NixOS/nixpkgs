{ stdenv, fetchurl, intltool, pkgconfig, gnome3, ncurses
, pythonSupport ? false, python, pygtk}:

stdenv.mkDerivation rec {

  versionMajor = "0.34";
  versionMinor = "9";
  moduleName   = "vte";
  
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1q93dsxg56f57mxblmh8kn4v9kyc643j2pjf1j3mn2kxypnwaf3g";
  };

  buildInputs = [ intltool pkgconfig gnome3.glib gnome3.gtk ncurses ] ++
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
    maintainers = with stdenv.lib.maintainers; [ astsmtl antono ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
