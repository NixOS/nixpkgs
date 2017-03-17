{ stdenv, fetchurl, pythonPackages, pkgconfig, SDL
, libpng, ffmpeg, freetype, glew, mesa, fribidi, zlib
}:

with pythonPackages;

stdenv.mkDerivation {
  name = "renpy-6.17.6";

  meta = {
    description = "Ren'Py Visual Novel Engine";
    homepage = "http://renpy.org/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    # This is an ancient version, last updated in 2014 (3d59f42ce); it fails to
    # build with the most recent pygame version, and fails to run with 1.9.1.
    broken = true;
  };

  src = fetchurl {
    url = "http://www.renpy.org/dl/6.17.6/renpy-6.17.6-source.tar.bz2";
    sha256 = "0rkynw9cnr1zqdinz037d9zig6grhp2ca2pyxk80vhdpjb0xrkic";
  };

  buildInputs = [
    python cython pkgconfig wrapPython
    SDL libpng ffmpeg freetype glew mesa fribidi zlib pygame
  ];

  pythonPath = [ pygame ];

  RENPY_DEPS_INSTALL = stdenv.lib.concatStringsSep "::" (map (path: "${path}") [
    SDL SDL.dev libpng ffmpeg ffmpeg.out freetype glew.dev glew.out mesa fribidi zlib
  ]);

  buildPhase = ''
    python module/setup.py build
  '';

  installPhase = ''
    mkdir -p $out/share/renpy
    cp -r renpy renpy.py $out/share/renpy
    python module/setup.py install --prefix=$out --install-lib=$out/share/renpy/module

    wrapPythonPrograms
    makeWrapper ${python}/bin/python $out/bin/renpy \
      --set PYTHONPATH $program_PYTHONPATH \
      --set RENPY_BASE $out/share/renpy \
      --add-flags "-O $out/share/renpy/renpy.py"
  '';

  NIX_CFLAGS_COMPILE = "-I${pygame}/include/${python.libPrefix}";
}
