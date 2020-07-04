{ stdenv
, fetchurl
, pkgconfig
, gstreamer
, gst-plugins-base
, python3
, gobject-introspection
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-validate";
  version = "1.16.2";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1jpfrzg3yc6kp66bgq3jy14xsj3x71mk2zh0k16yf0326awwqqa8";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
  ];

  buildInputs = [
    python3
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
