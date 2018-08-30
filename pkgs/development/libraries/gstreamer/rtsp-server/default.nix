{ stdenv, fetchurl, meson, ninja, pkgconfig
, gst-plugins-base, gettext, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-${version}";
  version = "1.14.2";

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
    sha256 = "161c49hg21xpkdw5ppc7ljbg6kyslxd1y3v1shsg7ibarxapff7p";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext gobjectIntrospection pkgconfig ];

  buildInputs = [ gst-plugins-base ];
}
