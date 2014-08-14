{ stdenv, fetchurl, pkgconfig, e18, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.10.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.gz";
    sha256 = "1nwlrk9inrhiv6jpzji10ikcdlhzhz7f2b5qhi2ai8bb6j61ryyc";
  };
  buildInputs = [ pkgconfig e18.efl vlc ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e18.efl}/include/eo-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "Extra video decoders";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
