{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gstreamer
, gst-plugins-base
, python3
, gobject-introspection
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-devtools";
  version = "1.18.5";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-/s/8hkR9r1wqBoQ8dXqZHXRcqiBpRGoNdG6ZsT98sHk=";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
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
    python3
    json-glib
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=disabled"
  ];

  meta = with lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
