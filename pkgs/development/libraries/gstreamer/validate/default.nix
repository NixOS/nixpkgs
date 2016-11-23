{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobjectIntrospection, json_glib
}:

stdenv.mkDerivation rec {
  name = "gst-validate-1.10.1";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "0x9z0kizi44swsrx8mdc6xlmn9dksdfifchp5h6liibp7qd6gbh7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobjectIntrospection
  ];

  buildInputs = [
    python json_glib
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;
}

