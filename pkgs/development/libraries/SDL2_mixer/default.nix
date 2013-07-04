{ stdenv, fetchurl, SDL2, libogg, libvorbis, enableNativeMidi ? false }:

stdenv.mkDerivation rec {
  name = "SDL2_mixer-2.0.0";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_mixer/release/${name}.tar.gz";
    sha256 = "0dpqh6ak77wvxwk06ak57vm79n27jbqfxzv5hv2yyzfj0852pmx3";
  };

  buildInputs = [SDL2 libogg libvorbis];

  configureFlags = "--disable-music-ogg-shared" + stdenv.lib.optionalString enableNativeMidi "--enable-music-native-midi-gpl";

  postInstall = "ln -s $out/include/SDL2/SDL_mixer.h $out/include/";

  meta = {
    description = "SDL multi-channel audio mixer library";
  };
}
