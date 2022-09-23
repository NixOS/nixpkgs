{ lib, stdenv, pkg-config, darwin, fetchurl, SDL2, freetype, libGL }:

stdenv.mkDerivation rec {
  pname = "SDL2_ttf";
  version = "2.0.15";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${pname}-${version}.tar.gz";
    sha256 = "0cyd48dipc0m399qy8s03lci8b0bpiy8xlkvrm2ia7wcv0dfpv59";
  };

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ SDL2 freetype libGL ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc;

  meta = with lib; {
    description = "SDL TrueType library";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = "https://www.libsdl.org/projects/SDL_ttf/";
  };
}
