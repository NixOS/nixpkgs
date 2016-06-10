{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "gst-validate-1.8.1";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-validate/${name}.tar.xz";
    sha256 = "1gycl6bbrf9ryis6wdinv4zi7552lz9izw4ram8xr8nc2k00icm9";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [
    pkgconfig gobjectIntrospection
  ];

  buildInputs = [
    python
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;
}

