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
  version = "1.16.1";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0i01f1nr0921z6z4nrh8icz76s2n7i228aqxg1ihvxl65ynsraxh";
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
