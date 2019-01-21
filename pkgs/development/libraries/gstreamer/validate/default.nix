{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobject-introspection, json-glib
}:

stdenv.mkDerivation rec {
  name = "gst-validate-${version}";
  version = "1.15.1";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "195hwblagfsnq1xn858al3f32jn5nynr4j5x395dpg3vl3c4k5v4";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobject-introspection
  ];

  buildInputs = [
    python json-glib
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
  ];
}
