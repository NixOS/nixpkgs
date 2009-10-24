{stdenv, fetchurl, perl, zlib, libjpeg, freetype, 
  SDL, libX11, xproto, xextproto, libXext, libpng}:

stdenv.mkDerivation {
  name = "directfb-1.1.0";
  src = fetchurl {
    url = http://www.directfb.org/downloads/Core/DirectFB-1.1.0.tar.gz;
    sha256 = "0fpjlgsyblvcjvqk8m3va2xsyx512mf26kwfsxarj1vql9b75s0f";
  };
  buildInputs = [perl zlib libjpeg freetype SDL
    xproto libX11 libXext xextproto libpng];
  configureFlags = [
    "--enable-sdl"
    "--enable-zlib"
    "--with-gfxdrivers=all"
    ];
}
