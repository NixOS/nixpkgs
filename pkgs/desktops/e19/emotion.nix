{ stdenv, fetchurl, pkgconfig, e19, vlc }:
stdenv.mkDerivation rec {
  name = "emotion_generic_players-${version}";
  version = "1.13.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/emotion_generic_players/${name}.tar.gz";
    sha256 = "0gin3cjhfj75v0gjsvv7harbj4fs4r7r1sfi74ncxzna71nrd8r3";
  };
  buildInputs = [ pkgconfig e19.efl vlc ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eo-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "Extra video decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
