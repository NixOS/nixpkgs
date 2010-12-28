{ stdenv, fetchurl, pkgconfig, pulseaudio, alsaLib
, usePulseAudio }:

stdenv.mkDerivation {
  name = "libao-0.8.8";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/ao/libao-0.8.8.tar.gz;
    sha256 = "e52e05af6b10f42d2ee9845df1a581bf2b352060eabf7946aee0a600c3878954";
  };

  buildInputs = [ pkgconfig alsaLib ] ++ (if usePulseAudio then [ pulseaudio ]
    else [ alsaLib ]);

  meta = {
    longDescription = ''
      Libao is Xiph.org's cross-platform audio library that allows
      programs to output audio using a simple API on a wide variety of
      platforms.
    '';
    homepage = http://xiph.org/ao/;
    license = "GPLv2+";
  };
}
