{ stdenv, fetchurl, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-2.2.4";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0x2d9hds5yazwdakkhrh3dk5qxscb169imi056q2qq53zhdyw6jy";
  };

  patches = [ ./webcore-svg-libxml-cflags.patch ];

  prePatch = ''
    patchShebangs Tools/gtk

    for i in $(find . -name '*.p[l|m]'); do
      sed -e 's@/usr/bin/gcc@gcc@' -i $i
    done
  '';

  configureFlags = [
    "--disable-geolocation"
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
    gst-plugins-base
  ];

  propagatedBuildInputs = [ gtk3 libsoup ];

  #enableParallelBuilding = true; # build problems on Hydra
}
