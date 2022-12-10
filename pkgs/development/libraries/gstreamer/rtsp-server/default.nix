{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, gettext
, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  pname = "gst-rtsp-server";
  version = "1.20.3";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-7kAnGL6bEn8OXmbKTBtPQuSSbsk7owe3zMpdxsyXlMo=";
  };

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    pkg-config
    python3

    # documentation
    # TODO add hotdoc here
  ];

  buildInputs = [
    gst-plugins-base
    gst-plugins-bad
    gobject-introspection
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
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
