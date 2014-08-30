{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc
, a52dec, libcdio, libdvdread
, lame, libmad, libmpeg2, x264
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-1.4.1";

  meta = with stdenv.lib; {
    description = "Gstreamer Ugly Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that have good quality and correct functionality,
      but distributing them might pose problems.  The license on either
      the plug-ins or the supporting libraries might not be how we'd
      like. The code might be widely known to present patent problems.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz";
    sha256 = "25440435ac4ed795d213f2420a0e7355e4a2e2e76d1f9d020b2073f815e8b071";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    a52dec libcdio libdvdread
    lame libmad libmpeg2 x264
  ];
}
