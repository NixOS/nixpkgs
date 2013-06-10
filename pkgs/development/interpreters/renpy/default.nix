{ stdenv, fetchurl, python, pkgconfig, wrapPython
, pygame, SDL, libpng, ffmpeg, freetype, glew, mesa, fribidi, zlib
}:

stdenv.mkDerivation {
  name = "renpy-6.15.5";

  src = fetchurl {
    url = "http://www.renpy.org/dl/6.15.5/renpy-6.15.5-source.tar.bz2";
    sha256 = "1k57dak1yk5iyxripqn2syhwwkh70y00pnnb9i1qf19lmiirxa60";
  };

  buildInputs = [
    python pkgconfig wrapPython
    SDL libpng ffmpeg freetype glew mesa fribidi zlib pygame
  ];

  pythonPath = [ pygame ];

  RENPY_DEPS_INSTALL = stdenv.lib.concatStringsSep "::" (map (path: "${path}") [
    SDL libpng ffmpeg freetype glew mesa fribidi zlib
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
      --set RENPY_LESS_UPDATES 1 \
      --add-flags "-O $out/share/renpy/renpy.py"
  '';

  NIX_CFLAGS_COMPILE = "-I${pygame}/include/${python.libPrefix}";

  meta = {
    description = "Ren'Py Visual Novel Engine";
    homepage = "http://renpy.org/";
    licence = "MIT";
    platforms = stdenv.lib.platforms.linux;
  };
}
