{ stdenv, fetchurl, pkgconfig, e19, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.14.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.gz";
    sha256 = "1n1a5n2wi68n8gjw4yk6cyf11djpqpac0025vysn5w6dqgccfic3";
  };
  buildInputs = [ pkgconfig e19.efl vlc ];
  NIX_CFLAGS_COMPILE = [ "-I${e19.efl}/include/eo-1" ];
  meta = {
    description = "Extra video decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
