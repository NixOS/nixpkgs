{ stdenv, fetchurl, SDL, libogg, libvorbis }:

stdenv.mkDerivation rec {
  pname = "SDL_mixer";
  version = "1.2.8";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/${pname}/release/${name}.tar.gz";
    sha256 = "a8222a274778ff16d0e3ee49a30db27a48a4d357169a915fc599a764e405e0b6";
  };

  buildInputs = [SDL libogg libvorbis];

  configureFlags = "--disable-music-ogg-shared";

  postInstall = "ln -s $out/include/SDL/SDL_mixer.h $out/include/";

  meta = {
    description = "SDL multi-channel audio mixer library";
  };
}
