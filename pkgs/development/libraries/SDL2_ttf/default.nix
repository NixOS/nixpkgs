{ stdenv, fetchurl, SDL2, freetype, mesa_noglu }:

stdenv.mkDerivation rec {
  name = "SDL2_ttf-${version}";
  version = "2.0.14";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "0xljwcpvd2knrjdfag5b257xqayplz55mqlszrqp0kpnphh5xnrl";
  };

  buildInputs = [ SDL2 freetype mesa_noglu ];

  meta = with stdenv.lib; {
    description = "SDL TrueType library";
    platforms = platforms.linux;
    license = licenses.zlib;
    homepage = https://www.libsdl.org/projects/SDL_ttf/;
  };
}
