{ vte, fetchFromGitHub, fetchpatch, autoconf, automake, gtk-doc, gettext, libtool, gperf
, stdenv, fetchurl, intltool, pkgconfig
, gnome3, glib, gtk3, ncurses, gobject-introspection, vala, libxml2, gnutls
, pcre2
}:

stdenv.mkDerivation rec {
  name = "vte-ng-${version}";
  version = "0.54.2.a";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "vte-ng";
    rev = version;
    sha256 = "1r7d9m07cpdr4f7rw3yx33hmp4jmsk0dn5byq5wgksb2qjbc4ags";
  };

  patches = [
    # Fix build with vala 0.44
    # See: https://github.com/thestinger/vte-ng/issues/32
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/vte/commit/53690d5cee51bdb7c3f7680d3c22b316b1086f2c.patch";
      sha256 = "1jrpqsx5hqa01g7cfqrsns6vz51mwyqwdp43ifcpkhz3wlp5dy66";
    })
  ];

  nativeBuildInputs = [
    gtk-doc autoconf automake gettext libtool gperf
    gobject-introspection intltool pkgconfig vala gperf libxml2
  ];
  buildInputs = [ glib gtk3 ncurses ];

  propagatedBuildInputs = [
    # Required by vte-2.91.pc.
    gtk3
    gnutls
    pcre2
  ];

  preConfigure = "patchShebangs .; NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [ "--enable-introspection" "--disable-Bsymbolic" ];

  meta = with stdenv.lib; {
    homepage = https://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.unix;
  };
}
