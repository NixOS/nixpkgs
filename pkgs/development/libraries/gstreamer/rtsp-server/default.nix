{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, hotdoc
, gettext
, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  pname = "gst-rtsp-server";
  version = "1.22.2";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-K+Suz7iHEBAOpxFe0CFkA+gJQ0Tr8UYJQnG41Nc4KL8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    pkg-config
    python3

    # documentation
    hotdoc
  ];

  buildInputs = [
    gst-plugins-base
    gst-plugins-bad
    gobject-introspection
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
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
