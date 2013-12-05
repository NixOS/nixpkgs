{ stdenv, fetchurl, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-2.2.3";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "01a69v0aw3bv2zkx6jzk71r3pjlf2xfhxavjnma89kmd78qb7g4l";
  };

  patches = [ ./webcore-svg-libxml-cflags.patch ];

  prePatch = ''
    for i in $(find . -name '*.p[l|m]'); do
      sed -e 's@/usr/bin/gcc@gcc@' -i $i
    done
  '';

  configureFlags = [
    "--disable-geolocation"
    "--disable-video"              # TODO: gsteramer-1.0
    "--enable-introspection"
  ];

  dontAddDisableDepTrack = true;

  nativeBuildInputs = [
    perl python ruby bison gperf flex
    pkgconfig which gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 wayland libwebp enchant
    libxml2 libsecret libxslt harfbuzz
  ];

  propagatedBuildInputs = [ gtk3 libsoup ];

  enableParallelBuilding = true;
}
