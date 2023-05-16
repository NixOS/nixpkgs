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
<<<<<<< HEAD
  version = "1.22.5";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-Kt0VGapu6wHVRMuUKTaI7jvCB59rymB1v1wj0AoJIb4=";
=======
  version = "1.22.2";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-62JybT4nqHgjaaJP1jZKiIXtJGKzu9qwkd/8gTnuBtg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ lilyinstarlight ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
