{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gst-plugins-base, orc, gettext
, a52dec, libcdio, libdvdread
, libmad, libmpeg2, x264, libintl
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-1.14.0";

  meta = with stdenv.lib; {
    description = "Gstreamer Ugly Plugins";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that have good quality and correct functionality,
      but distributing them might pose problems.  The license on either
      the plug-ins or the supporting libraries might not be how we'd
      like. The code might be widely known to present patent problems.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz";
    sha256 = "1la2nny9hfw3rf3wvqggkg8ivn52qrqqs4n4mqz4ppm2r1gymf9z";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    a52dec libcdio libdvdread
    libmad libmpeg2 x264
    libintl
  ];
}
