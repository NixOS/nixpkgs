{ stdenv, fetchurl, pkgconfig, e19, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.11.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.gz";
    sha256 = "0x6aigsqnfn9vcaj1rj6055s0vh811svzhwz5zghksg4lqipjbjx";
  };
  buildInputs = [ pkgconfig e19.efl vlc ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eo-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "Extra video decoders";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
