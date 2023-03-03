{ lib, stdenv
, fetchurl
, cairo
, meson
, ninja
, pkg-config
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, gst-rtsp-server
, python3
, gobject-introspection
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-devtools";
  version = "1.20.3";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-u71F6tcDNn6o9L6bPAgte2K+9HskCjkIPyeETih1jEc=";
  };

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection

    # documentation
    # TODO add hotdoc here
  ];

  buildInputs = [
    cairo
    python3
    json-glib
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-rtsp-server
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  meta = with lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
