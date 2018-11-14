{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobjectIntrospection, json-glib
}:

stdenv.mkDerivation rec {
  name = "gst-validate-${version}";
  version = "1.14.2";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "17zilvmwv13l6rbj0a7dnbg4kz5bwwa1gshaibpqbvvhahz457pa";
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
