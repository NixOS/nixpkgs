{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gstreamer
, gst-plugins-base
, python3
, gobject-introspection
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-devtools";
  version = "1.18.2";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0mhascwvgirgh7b5dykpnk06f7f5g62gh3sl30i6kygiidqkv9vf";
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
    pkgconfig
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
  ];

  meta = with stdenv.lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
