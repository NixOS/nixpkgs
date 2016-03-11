{ stdenv, fetchurl, pkgconfig, efl, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.17.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.xz";
    sha256 = "03kaql95mk0c5j50v3c5i5lmlr3gz7xlh8p8q87xz8zf9j5h1pp7";
  };
  buildInputs = [ pkgconfig efl vlc ];
  NIX_CFLAGS_COMPILE = [ "-I${efl}/include/eo-1" ];
  meta = {
    description = "Extra video decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
