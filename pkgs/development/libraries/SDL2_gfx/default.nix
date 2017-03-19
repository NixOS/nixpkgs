{ stdenv, fetchurl, SDL2 }:

stdenv.mkDerivation rec {
  name = "SDL2_gfx-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/sdl2gfx/${name}.tar.gz";
    sha256 = "16jrijzdp095qf416zvj9gs2fqqn6zkyvlxs5xqybd0ip37cp6yn";
  };

  buildInputs = [ SDL2 ];

  configureFlags = if stdenv.isi686 || stdenv.isx86_64 then "--enable-mmx" else "--disable-mmx";

  meta = with stdenv.lib; {
    description = "SDL graphics drawing primitives and support functions";

    longDescription = ''
      The SDL_gfx library evolved out of the SDL_gfxPrimitives code
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
    platforms = platforms.linux;
  };
}
