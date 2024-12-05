{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, python3
, bash-completion
, gst-plugins-base
, gst-plugins-bad
, gst-devtools
, libxml2
, flex
, gettext
, gobject-introspection
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

stdenv.mkDerivation rec {
  pname = "gst-editing-services";
  version = "1.24.7";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-sjzDEqI/q3F+S2A/ByvkIJhPucndIHfiBraqmxHfKdg=";
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

    # Hack for https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/3800
    substituteInPlace ges/ges-frame-composition-meta.c \
      --replace-fail "GstFrameCompositionApi" "GESFrameCompositionApi"
  '';

  meta = with lib; {
    description = "Library for creation of audio/video non-linear editors";
    mainProgram = "ges-launch-1.0";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
