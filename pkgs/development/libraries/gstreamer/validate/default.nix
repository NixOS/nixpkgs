{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gst-validate-1.8.2";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "33c5b585c5ca1659fe6c09fdf02e45d8132c0d386b405bf527b14ab481a0bafe";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobjectIntrospection
  ];

  buildInputs = [
    python
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;
}

