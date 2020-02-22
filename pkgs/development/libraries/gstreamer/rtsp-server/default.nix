{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gettext
, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  pname = "gst-rtsp-server";
  version = "1.16.2";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0vn23nxwvs96g7gcxw5zbnw23hkhky8a8r42wq68411vgf1s41yy";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    pkgconfig
  ];

  buildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  meta = with stdenv.lib; {
    description = "GStreamer RTSP server";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      A library on top of GStreamer for building an RTSP server.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bkchr ];
  };
}
