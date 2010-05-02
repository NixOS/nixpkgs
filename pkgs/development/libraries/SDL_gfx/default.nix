{stdenv, fetchurl, SDL} :

stdenv.mkDerivation rec {
  name = "SDL_gfx-2.0.20";

  src = fetchurl {
    url = "http://www.ferzkopp.net/Software/SDL_gfx-2.0/${name}.tar.gz";
    sha256 = "0dyc1sj0ymv2ghmlgwfb2c6r07scbgmi2dfhmnddsb27y8wjqz4q";
  };

  buildInputs = [ SDL ] ;

  configureFlags = "--disable-mmx";

  postInstall = "ln -s $out/include/SDL/*.h $out/include/";

  meta = {
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

    homepage = https://sourceforge.net/projects/sdlgfx/;
    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
