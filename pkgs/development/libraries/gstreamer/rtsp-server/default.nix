{ stdenv, fetchurl, meson, ninja, pkgconfig
, gettext, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-${version}";
  version = "1.15.1";

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
    sha256 = "0d0jaf7ir40dxpxs41wyb7m7riyl7wsqcb5qvd4vhwpz0dwxhpvl";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext gobject-introspection pkgconfig ];

  buildInputs = [ gst-plugins-base gst-plugins-bad ];

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];
}
