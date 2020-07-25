{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_gfx";
  version = "2.0.26";

  src = fetchurl {
    url = "https://www.ferzkopp.net/Software/SDL_gfx-2.0/${pname}-${version}.tar.gz";
    sha256 = "0ijljhs0v99dj6y27hc10z6qchyp8gdp4199y6jzngy6dzxlzsvw";
  };

  buildInputs = [ SDL ] ;

  configureFlags = [ "--disable-mmx" ]
    ++ stdenv.lib.optional stdenv.isDarwin "--disable-sdltest";

  meta = with stdenv.lib; {
    description = "SDL graphics drawing primitives and support functions";

    longDescription =
      '' The SDL_gfx library evolved out of the SDL_gfxPrimitives code
	 which provided basic drawing routines such as lines, circles or
	 polygons and SDL_rotozoom which implemented a interpolating
	 rotozoomer for SDL surfaces.

	 The current components of the SDL_gfx library are:

	    * Graphic Primitives (SDL_gfxPrimitves.h)
	    * Rotozoomer (SDL_rotozoom.h)
	    * Framerate control (SDL_framerate.h)
	    * MMX image filters (SDL_imageFilter.h)
	    * Custom Blit functions (SDL_gfxBlitFunc.h)

	 The library is backwards compatible to the above mentioned
         code. Its is written in plain C and can be used in C++ code.
       '';

    homepage = "https://sourceforge.net/projects/sdlgfx/";
    license = licenses.zlib;

    maintainers = with maintainers; [ bjg ];
    platforms = platforms.unix;
  };
}
