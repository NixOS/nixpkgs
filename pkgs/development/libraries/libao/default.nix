{ lib, stdenv, fetchurl, pkgconfig, pulseaudio, alsaLib
, usePulseAudio }:

stdenv.mkDerivation {
  name = "libao-1.1.0";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/ao/libao-1.1.0.tar.gz;
    sha256 = "1m0v2y6bhr4iwsgdkc7b3y0qgpvpv1ifbxsy8n8ahsvjn6wmppi9";
  };

  buildInputs = 
    [ pkgconfig ] ++
    lib.optional stdenv.isLinux (if usePulseAudio then [ pulseaudio ] else [ alsaLib ]);

  meta = {
    longDescription = ''
      Libao is Xiph.org's cross-platform audio library that allows
      programs to output audio using a simple API on a wide variety of
      platforms.
    '';
    homepage = http://xiph.org/ao/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
