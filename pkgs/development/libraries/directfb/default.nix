{stdenv, fetchurl, perl, zlib, libjpeg, freetype, 
  SDL, libX11, xproto, xextproto, libXext, libpng,
  renderproto, libXrender, giflib}:
let s = import ./src-for-default.nix; in
stdenv.mkDerivation {
  inherit (s) name;
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
  };
  buildInputs = [perl zlib libjpeg freetype SDL
    xproto libX11 libXext xextproto libpng
    renderproto libXrender giflib
    ];
  NIX_LDFLAGS="-lgcc_s";
  configureFlags = [
    "--enable-sdl"
    "--enable-zlib"
    "--with-gfxdrivers=all"
    "--enable-devmem"
    "--enable-fbdev"
    "--enable-x11"
    "--enable-mmx"
    "--enable-sse"
    "--enable-sysfs"
    "--with-software"
    "--with-smooth-scaling"
    ];
}
