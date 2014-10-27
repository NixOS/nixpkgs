{ stdenv, fetchurl, intltool, pkgconfig, gnome3, ncurses, gobjectIntrospection, vala, libxml2
, selectTextPatch ? false }:

stdenv.mkDerivation rec {
  versionMajor = "0.38";
  versionMinor = "0";
  moduleName   = "vte";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1llg2xnjpn630vd86ci8csbjjacj3ia6syck2bsq4kinr66z5zsw";
  };

  patches = with stdenv.lib; optional selectTextPatch ./expose_select_text.patch;

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib gnome3.gtk3 ncurses vala libxml2 ];

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  preBuild = "patchShebangs ./src";

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la --replace "-lncurses" "-L${ncurses}/lib -lncurses"
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
