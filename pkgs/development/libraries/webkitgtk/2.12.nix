{ stdenv, fetchurl, perl, python, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection, libnotify
, gtk2, gtk3, wayland, libwebp, enchant, xlibs, libxkbcommon, epoxy, at_spi2_core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs
, enableGeoLocation ? true, geoclue2, sqlite
, gst-plugins-base
}:

assert enableGeoLocation -> geoclue2 != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.12.0";

  meta = {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ koral ];
  };

  preConfigure = "patchShebangs Tools";

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "19jyvyw8ss4bacq3f7ybdb0r16r84q12j2bpciyj9jqvzpw091m6";
  };

  patches = [ ./finding-harfbuzz-icu.patch ];

  cmakeFlags = [ "-DPORT=GTK" "-DUSE_LIBHYPHEN=0" ];

  # XXX: WebKit2 missing include path for gst-plugins-base.
  # Filled: https://bugs.webkit.org/show_bug.cgi?id=148894
  NIX_CFLAGS_COMPILE = "-I${gst-plugins-base}/include/gstreamer-1.0";

  nativeBuildInputs = [
    cmake perl python ruby bison gperf sqlite
    pkgconfig gettext gobjectIntrospection
  ] ++ (with xlibs; [ libXdmcp ]);

  buildInputs = [
    gtk2 wayland libwebp enchant libnotify
    libxml2 libsecret libxslt harfbuzz libpthreadstubs
    gst-plugins-base libxkbcommon epoxy at_spi2_core
  ] ++ optional enableGeoLocation geoclue2
    ++ (with xlibs; [ libXt libXtst ]);

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  enableParallelBuilding = true;
}
