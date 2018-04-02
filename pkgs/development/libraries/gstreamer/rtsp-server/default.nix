{ stdenv, fetchurl, pkgconfig, gst-plugins-base }:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-1.12.3";

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
    sha256 = "1v3lghx75l05hssgwxdxsgrxpn10gxlgkfb6vq0rl0hnpdqmj9b7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gst-plugins-base ];
}
