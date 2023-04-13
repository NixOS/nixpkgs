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
, hotdoc
, gettext
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gst-editing-services";
  version = "1.22.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-RTsUZPw4V94mmnyw69lmr+Ahcdl772cqC4oKbUPgzr8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    python3
    flex

    # documentation
    hotdoc
  ];

  buildInputs = [
    bash-completion
    libxml2
    gobject-introspection
    gst-devtools
    python3
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
