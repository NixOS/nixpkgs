{stdenv, fetchsvn, SDL2} :

let rev = 5; in
stdenv.mkDerivation rec {
  name = "SDL2_gfx-${toString rev}";

  src = fetchsvn {
    url = http://svn.code.sf.net/p/sdl2gfx/code/trunk;
    inherit rev;
    sha256 = "1hzilbn1412m2b44mygrbdfh1gvks4v5p0kmafz248jf9ifsvmzp";
  };

  buildInputs = [ SDL2 ] ;

  configureFlags = "--disable-mmx";

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL2/SDL.h>,' \
      $out/include/SDL2/*.h
    
    ln -s $out/include/SDL2/SDL2_framerate.h $out/include/SDL2/SDL_framerate.h;
    ln -s $out/include/SDL2/SDL2_gfxPrimitives.h $out/include/SDL2/SDL_gfxPrimitives.h;
    ln -s $out/include/SDL2/SDL2_rotozoom.h $out/include/SDL2/SDL_rotozoom.h;
    ln -s $out/include/SDL2/*.h $out/include/;
  '';

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
    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.linux;
  };
}
