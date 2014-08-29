{ lib, stdenv, fetchurl, pkgconfig, pulseaudio, alsaLib
, usePulseAudio }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "libao-${version}";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ao/${name}.tar.gz";
    sha256 = "1bwwv1g9lchaq6qmhvj1pp3hnyqr64ydd4j38x94pmprs4d27b83";
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
