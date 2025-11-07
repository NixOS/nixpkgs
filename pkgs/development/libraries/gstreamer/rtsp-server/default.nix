{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  gettext,
  gobject-introspection,
  gst-plugins-base,
  gst-plugins-bad,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-rtsp-server";
  version = "1.26.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-Mo3/JFdBloPypPBsoRnP0ivrYyzuGtaDBZEhMyU1PEQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    pkg-config
    python3
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  mesonFlags = [
    "-Dglib_debug=disabled" # cast checks should be disabled on stable releases
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  passthru = {
    updateScript = directoryListingUpdater { };
  };

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
})
