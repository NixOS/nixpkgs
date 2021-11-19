{ lib, stdenv, darwin, fetchurl, pkg-config, SDL2 }:

stdenv.mkDerivation rec {
  pname = "SDL2_gfx";
  version = "1.0.4";

  src = fetchurl {
    url = "http://www.ferzkopp.net/Software/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0qk2ax7f7grlxb13ba0ll3zlm8780s7j8fmrhlpxzjgdvldf1q33";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ SDL2 ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc;

  configureFlags = [(if stdenv.isi686 || stdenv.isx86_64 then "--enable-mmx" else "--disable-mmx")]
     ++ lib.optional stdenv.isDarwin "--disable-sdltest";

  meta = with lib; {
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

    homepage = "http://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/";
    license = licenses.zlib;
    maintainers = with maintainers; [ cpages ];
    platforms = platforms.unix;
  };
}
