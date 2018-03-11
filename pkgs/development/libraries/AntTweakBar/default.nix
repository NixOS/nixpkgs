{ stdenv, fetchurl, unzip, xlibs, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "AntTweakBar-1.16";

  buildInputs = [ unzip xlibs.libX11 libGLU_combined ];

  src = fetchurl {
    url = "mirror://sourceforge/project/anttweakbar/AntTweakBar_116.zip";
    sha256 = "0z3frxpzf54cjs07m6kg09p7nljhr7140f4pznwi7srwq4cvgkpv";
  };

  postPatch = "cd src";
  installPhase = ''
    mkdir -p $out/lib/
    cp ../lib/{libAntTweakBar.so,libAntTweakBar.so.1,libAntTweakBar.a} $out/lib/
    cp -r ../include $out/
  '';

  meta = {
    description = "Add a light/intuitive GUI to OpenGL applications";
    longDescription = ''
      A small and easy-to-use C/C++ library that allows to quickly add a light
      and intuitive graphical user interface into graphic applications based on OpenGL
      (compatibility and core profiles), DirectX 9, DirectX 10 or DirectX 11
      to interactively tweak parameters on-screen
    '';
    homepage = http://anttweakbar.sourceforge.net/;
    license = stdenv.lib.licenses.zlib;
    maintainers = [ stdenv.lib.maintainers.razvan ];
    platforms = stdenv.lib.platforms.linux;
  };
}
