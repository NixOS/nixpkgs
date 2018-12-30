{ stdenv, fetchurl, gettext, gobject-introspection, pkgconfig
, meson, ninja, glibcLocales, git, vala, glib, zlib
}:

stdenv.mkDerivation rec {
  name = "gcab-${version}";
  version = "1.2";

  LC_ALL = "en_US.UTF-8";

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/${version}/${name}.tar.xz";
    sha256 = "038h5kk41si2hc9d9169rrlvp8xgsxq27kri7hv2vr39gvz9cbas";
  };

  nativeBuildInputs = [ meson ninja glibcLocales git pkgconfig vala gettext gobject-introspection ];

  buildInputs = [ glib zlib ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dtests=false"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = [ maintainers.lethalman ];
  };

}
