{ stdenv, fetchurl, intltool, pkgconfig, gnome3, ncurses, gobjectIntrospection, vala, libxml2
, gnutls, selectTextPatch ? false }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  patches = with stdenv.lib; optional selectTextPatch ./expose_select_text.0.40.0.patch;

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib 
                  gnome3.gtk3 ncurses vala libxml2 ];

  propagatedBuildInputs = [ gnutls ];

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la --replace "-lncurses" "-L${ncurses.lib}/lib -lncurses"
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
