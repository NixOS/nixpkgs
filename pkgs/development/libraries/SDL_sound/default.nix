{ stdenv, fetchurl, SDL, libvorbis, flac, libmikmod }:

stdenv.mkDerivation rec {
  name = "SDL_sound-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "http://icculus.org/SDL_sound/downloads/${name}.tar.gz";
    sha256 = "1pz6g56gcy7pmmz3hhych3iq9jvinml2yjz15fjqjlj8pc5zv69r";
  };

  buildInputs = [ SDL libvorbis flac libmikmod ];

  meta = with stdenv.lib; {
    description = "SDL sound library";
    platforms = platforms.linux;
    license = licenses.lgpl21;
    homepage = https://www.icculus.org/SDL_sound/;
  };
}
