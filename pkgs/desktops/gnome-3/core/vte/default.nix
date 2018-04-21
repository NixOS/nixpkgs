{ stdenv, fetchurl, intltool, pkgconfig
, gnome3, ncurses, gobjectIntrospection, vala, libxml2, gnutls
, fetchFromGitHub, autoconf, automake, libtool, gtk-doc, gperf, pcre2
}:

stdenv.mkDerivation rec {
  name = "vte-${version}";
  version = "0.52.1";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1lva70inb5y8p42rg95fb88z2ybwcz0lybla3ixbgp2sj0s4rzdh";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "vte"; attrPath = "gnome3.vte"; };
  };

  nativeBuildInputs = [ gobjectIntrospection intltool pkgconfig vala gperf libxml2 ];
  buildInputs = [ gnome3.glib gnome3.gtk3 ncurses ];

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

