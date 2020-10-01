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
  version = "1.18.0";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "05jzjkkdr5hg01mjihlqdcxqnjfrm4mqk0zp83212kv5nm0p2cw2";
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
