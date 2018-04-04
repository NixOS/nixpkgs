{ stdenv, fetchurl, meson, ninja, pkgconfig
, gst-plugins-base, gettext, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-1.14.0";

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
    sha256 = "0mlp9ms5hfbyzyvmc9xgi7934g4zrh1sbgky2p9zc5fqprvs0rbb";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext gobjectIntrospection pkgconfig ];

  buildInputs = [ gst-plugins-base ];
}
