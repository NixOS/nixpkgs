{ stdenv, fetchurl, gettext, gobjectIntrospection, pkgconfig
, meson, ninja, glibcLocales, git, vala, glib, zlib
}:

stdenv.mkDerivation rec {
  name = "gcab-${version}";
  version = "1.1";

  LC_ALL = "en_US.UTF-8";

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/${version}/${name}.tar.xz";
    sha256 = "0l19sr6pg0cfcddmi5n79d08mjjbhn427ip5jlsy9zddq9r24aqr";
  };

  nativeBuildInputs = [ meson ninja glibcLocales git pkgconfig vala gettext gobjectIntrospection ];

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
