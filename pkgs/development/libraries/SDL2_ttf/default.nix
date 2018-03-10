{ stdenv, darwin, fetchurl, SDL2, freetype, libGL }:

stdenv.mkDerivation rec {
  name = "SDL2_ttf-${version}";
  version = "2.0.14";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "0xljwcpvd2knrjdfag5b257xqayplz55mqlszrqp0kpnphh5xnrl";
  };

  buildInputs = [ SDL2 freetype libGL ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.libobjc;

  meta = with stdenv.lib; {
    description = "SDL TrueType library";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = https://www.libsdl.org/projects/SDL_ttf/;
  };
}
