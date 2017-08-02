{ stdenv, fetchurl, intltool, pkgconfig
, gnome3, ncurses, gobjectIntrospection, vala_0_32, libxml2, gnutls
, fetchFromGitHub, autoconf, automake, libtool, gtk_doc, gperf, pcre2
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib
                  gnome3.gtk3 ncurses vala_0_32 libxml2 ];

  propagatedBuildInputs = [ gnutls pcre2 ];

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-introspection" "--disable-Bsymbolic" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnome.org/;
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}

