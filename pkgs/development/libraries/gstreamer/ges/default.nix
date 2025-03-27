{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  bash-completion,
  gst-plugins-base,
  gst-plugins-bad,
  gst-devtools,
  libxml2,
  flex,
  gettext,
  gobject-introspection,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-editing-services";
  version = "1.26.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-${finalAttrs.version}.tar.xz";
    hash = "sha256-r1sn9ck2MCc3IQDKwLrxkFUoBynfHMWN1ORU72mOsf8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    python3
    flex
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    bash-completion
    libxml2
    gst-devtools
    python3
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ];

  mesonFlags = [
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
    description = "Library for creation of audio/video non-linear editors";
    mainProgram = "ges-launch-1.0";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
