{ stdenv, fetchurl, meson, ninja, pkgconfig
, gettext, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  name = "gst-rtsp-server-${version}";
  version = "1.16.0";

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
    sha256 = "069zy159izy50blci9fli1i2r8jh91qkmgrz1n0xqciy3bn9x3hr";
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
