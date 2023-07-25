{ stdenv, lib, fetchurl, SDL, libvorbis, flac, libmikmod }:

stdenv.mkDerivation rec {
  pname = "SDL_sound";
  version = "1.0.3";

  src = fetchurl {
    url = "https://icculus.org/SDL_sound/downloads/${pname}-${version}.tar.gz";
    sha256 = "1pz6g56gcy7pmmz3hhych3iq9jvinml2yjz15fjqjlj8pc5zv69r";
  };

  buildInputs = [ SDL libvorbis flac libmikmod ];

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  meta = with lib; {
    description = "SDL sound library";
    platforms = platforms.unix;
    license = licenses.lgpl21;
    homepage = "https://www.icculus.org/SDL_sound/";
  };
}
