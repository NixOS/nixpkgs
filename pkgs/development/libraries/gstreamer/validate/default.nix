{ stdenv
, fetchurl
, pkgconfig
, gstreamer
, gst-plugins-base
, python
, gobject-introspection
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-validate";
  version = "1.16.1";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1698arvmpb0cvyi8ll1brvs51vs7i3f3fw19iswh8xhj5adrn1vz";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
  ];

  buildInputs = [
    python
    json-glib
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
  ];

  meta = with stdenv.lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
