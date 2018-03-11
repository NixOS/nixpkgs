{ stdenv, fetchurl, pythonPackages, pkgconfig, SDL2
, libpng, ffmpeg, freetype, glew, libGLU_combined, fribidi, zlib
, glib
}:

with pythonPackages;

stdenv.mkDerivation {
  name = "renpy-6.99.12.4";

  meta = {
    description = "Ren'Py Visual Novel Engine";
    homepage = http://renpy.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    # This is an ancient version, last updated in 2014 (3d59f42ce); it fails to
    # build with the most recent pygame version, and fails to run with 1.9.1.
    broken = true;
  };

  src = fetchurl {
    url = "http://www.renpy.org/dl/6.99.12.4/renpy-6.99.12.4-source.tar.bz2";
    sha256 = "035342rr39zp7krp08z0xhcl73gqbqyilshgmljq0ynfrxxckn35";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python cython wrapPython
    SDL2 libpng ffmpeg freetype glew libGLU_combined fribidi zlib pygame_sdl2 glib
  ];

  pythonPath = [ pygame_sdl2 ];

  RENPY_DEPS_INSTALL = stdenv.lib.concatStringsSep "::" (map (path: "${path}") [
    SDL2 SDL2.dev libpng ffmpeg ffmpeg.out freetype glew.dev glew.out libGLU_combined fribidi zlib
  ]);

  buildPhase = ''
    python module/setup.py build
  '';

  installPhase = ''
    mkdir -p $out/share/renpy
    cp -r renpy renpy.py $out/share/renpy
    python module/setup.py install --prefix=$out --install-lib=$out/share/renpy/module

    makeWrapper ${python}/bin/python $out/bin/renpy \
      --set PYTHONPATH $PYTHONPATH \
      --set RENPY_BASE $out/share/renpy \
      --add-flags "-O $out/share/renpy/renpy.py"
  '';

  NIX_CFLAGS_COMPILE = "-I${pygame_sdl2}/include/${python.libPrefix}";
}
