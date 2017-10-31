{ stdenv, lib, fetchurl, SDL, libogg, libvorbis, smpeg, enableNativeMidi ? false, fluidsynth ? null }:

stdenv.mkDerivation rec {
  pname   = "SDL_mixer";
  version = "1.2.12";
  name    = "${pname}-${version}";

  src = fetchurl {
    url    = "http://www.libsdl.org/projects/${pname}/release/${name}.tar.gz";
    sha256 = "0alrhqgm40p4c92s26mimg9cm1y7rzr6m0p49687jxd9g6130i0n";
  };

  buildInputs = [ SDL libogg libvorbis fluidsynth smpeg ];

  configureFlags = [ "--disable-music-ogg-shared" ] ++ lib.optional enableNativeMidi " --enable-music-native-midi-gpl";

  meta = with stdenv.lib; {
    description = "SDL multi-channel audio mixer library";
    homepage    = http://www.libsdl.org/projects/SDL_mixer/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
