{ stdenv, fetchurl, meson, ninja, pkgconfig
, gst-plugins-base, gettext, gobject-introspection
}:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-${version}";
  version = "1.14.4";

  meta = with stdenv.lib; {
    description = "Gstreamer RTSP server";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a library on top of GStreamer for building an RTSP server.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bkchr ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-rtsp-server/${name}.tar.xz";
    sha256 = "1wc4d0y57hpfvv9sykjg8mxj86dw60mf696fbqbiqq6dzlmcw3ix";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext gobject-introspection pkgconfig ];

  buildInputs = [ gst-plugins-base ];
}
