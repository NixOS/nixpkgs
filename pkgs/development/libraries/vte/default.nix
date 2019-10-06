{ stdenv
, fetchurl
, gettext
, pkgconfig
, meson
, ninja
, gnome3
, glib
, gtk3
, gobject-introspection
, vala
, libxml2
, gnutls
, gperf
, pango
, pcre2
, fribidi
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vte";
  version = "0.58.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ifvza9sdrkxxqq7m9i7ry23sv7widjz6nzbvgc60kpph4fmf187";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = pname; };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gperf
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    fribidi
    gnutls
    pcre2
    zlib
  ];

  propagatedBuildInputs = [
    # Required by vte-2.91.pc.
    gtk3
    glib
    pango
  ];

  postPatch = ''
    patchShebangs perf/*
    patchShebangs src/box_drawing_generate.sh
  '';

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
