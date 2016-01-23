{ stdenv, fetchurl, pkgconfig, e19, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.16.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.xz";
    sha256 = "163ay26c6dx49m1am7vsxxn0gy877zhayxq0yxn9zkbq2srzvjym";
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
