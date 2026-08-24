{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  gstreamer,
  gst-plugins-base,
  gettext,
  # FIXME: unpin when upstream supports ffmpeg 9
  ffmpeg_8-headless,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-libav";
  version = "1.28.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${finalAttrs.version}.tar.xz";
    hash = "sha256-RShUZWBW8LFlEaHZrU8mef9eWofIn5DPfuXewAXdseQ=";
  };

  separateDebugInfo = true;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    ffmpeg_8-headless
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  mesonFlags = [
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  passthru = {
    updateScript = directoryListingUpdater { odd-unstable = true; };
  };

  meta = {
    description = "FFmpeg plugin for GStreamer";
    homepage = "https://gstreamer.freedesktop.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
