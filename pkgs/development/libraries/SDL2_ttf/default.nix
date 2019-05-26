{ stdenv, darwin, fetchurl, SDL2, freetype, libGL }:

stdenv.mkDerivation rec {
  name = "SDL2_ttf-${version}";
  version = "2.0.15";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "0cyd48dipc0m399qy8s03lci8b0bpiy8xlkvrm2ia7wcv0dfpv59";
  };

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-sdltest";

  buildInputs = [ SDL2 freetype libGL ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.libobjc;

  meta = with stdenv.lib; {
    description = "SDL TrueType library";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = https://www.libsdl.org/projects/SDL_ttf/;
  };
}
