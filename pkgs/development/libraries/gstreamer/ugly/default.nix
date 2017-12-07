{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc
, a52dec, libcdio, libdvdread
, lame, libmad, libmpeg2, x264, libintlOrEmpty
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-1.12.2";

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
    sha256 = "0rplyp1qk359c97ig9i2vc1v34g92khd8dslwfipva1ypwmr9hqw";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    a52dec libcdio libdvdread
    lame libmad libmpeg2 x264
  ] ++ libintlOrEmpty;

  NIX_LDFLAGS = if stdenv.isDarwin then "-lintl" else null;
}
