{stdenv, fetchurl, perl, zlib, libjpeg, freetype, libpng, giflib
, enableX11 ? true, libX11, xproto, xextproto, libXext, renderproto, libXrender
, enableSDL ? true, SDL }:

let s = import ./src-for-default.nix; in
stdenv.mkDerivation {
  inherit (s) name;
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
  };

  patches = [ ./ftbfs.patch ];

  buildNativeInputs = [ perl ];

  buildInputs = [ zlib libjpeg freetype giflib libpng ]
    ++ stdenv.lib.optional enableSDL SDL
    ++ stdenv.lib.optionals enableX11 [
      xproto libX11 libXext xextproto
      renderproto libXrender
    ];

  NIX_LDFLAGS="-lgcc_s";

  configureFlags = [
    "--enable-sdl"
    "--enable-zlib"
    "--with-gfxdrivers=all"
    "--enable-devmem"
    "--enable-fbdev"
    "--enable-mmx"
    "--enable-sse"
    "--enable-sysfs"
    "--with-software"
    "--with-smooth-scaling"
    ] ++ stdenv.lib.optionals enableX11 [
      "--enable-x11"
    ];
}
