{ stdenv, fetchurl, intltool, pkgconfig, gnome3, ncurses, gobjectIntrospection, gnutls, pcre2, vala, gperf, libxml2}:

stdenv.mkDerivation rec {
  versionMajor = "0.48";
  versionMinor = "3";
  moduleName   = "vte";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1hsqc7238862mqnva5qqdfxnhpwq3ak6zx6kbjj95cs04wcgpad3";
  };

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib gnome3.gtk3 ncurses vala gperf libxml2];

  propagatedBuildInputs = [ pcre2 gnutls ];

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/lib/libvte-2.91.la --replace "-lncurses" "-L${ncurses.out}/lib -lncurses"
  '';

  meta = with stdenv.lib; {
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
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.linux;
  };
}
