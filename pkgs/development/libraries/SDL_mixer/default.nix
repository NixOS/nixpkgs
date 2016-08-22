{ stdenv, fetchurl, SDL, libogg, libvorbis, smpeg, enableNativeMidi ? false, fluidsynth ? null }:

stdenv.mkDerivation rec {
  pname   = "SDL_mixer";
  version = "1.2.12";
  name    = "${pname}-${version}";

  src = fetchurl {
    url    = "http://www.libsdl.org/projects/${pname}/release/${name}.tar.gz";
    sha256 = "0alrhqgm40p4c92s26mimg9cm1y7rzr6m0p49687jxd9g6130i0n";
  };

  buildInputs = [SDL libogg libvorbis fluidsynth smpeg];

  configureFlags = "--disable-music-ogg-shared" + stdenv.lib.optionalString enableNativeMidi " --enable-music-native-midi-gpl";

  postInstall = ''
    ln -s $out/include/SDL/SDL_mixer.h $out/include/

    for f in $out/include/SDL/SDL_mixer.h
    do
      for i in SDL_types.h SDL_rwops.h SDL_audio.h SDL_endian.h SDL_version.h begin_code.h close_code.h
      do
        substituteInPlace $f --replace "#include \"$i\"" "#include <SDL/$i>"
      done
    done
  '';

  meta = with stdenv.lib; {
    description = "SDL multi-channel audio mixer library";
    homepage    = http://www.libsdl.org/projects/SDL_mixer/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
