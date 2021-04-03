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
  version = "1.16.3";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "187ywrzm628sr7m4rdizs21379javka5kmc8iz2i7m96523np237";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # To use split outputs, we need this so double prefix won't be used in the
    # pkg-config files. Hopefully, this won't be needed on the next release,
    # _if_
    # https://gitlab.freedesktop.org/gstreamer/gst-rtsp-server/merge_requests/1
    # will be merged. For the current release, this merge request won't apply.
    ./fix_pkgconfig_includedir.patch
  ];

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
