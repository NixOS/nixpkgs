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
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

stdenv.mkDerivation rec {
  pname = "gst-devtools";
  version = "1.22.12";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-AV/2J4natCPtr+l5sBnH3kyEmit+dJErILdKcOW2j3I=";
  };

  outputs = [
    "out"
    "dev"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    cairo
    python3
    json-glib
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-rtsp-server
  ];

  mesonFlags = [
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  meta = with lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
