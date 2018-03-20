{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobjectIntrospection, json-glib
}:

stdenv.mkDerivation rec {
  name = "gst-validate-1.12.4";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "18gvgavkqkcjq82v8hj9j0apg4iz5ns54mwcnfimnvsxdvz9vnpr";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobjectIntrospection
  ];

  buildInputs = [
    python json-glib
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;
}
