{ stdenv, fetchurl, pkgconfig, e19, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.15.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.gz";
    sha256 = "08yl473aiklj0yfxbn88000hmnhl7dbhqixsn22ias8a90rxdfhh";
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
