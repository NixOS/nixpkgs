{ stdenv, fetchurl, pkgconfig, perl, zlib, libjpeg, freetype, libpng, giflib
, enableX11 ? true, xorg
, enableSDL ? true, SDL }:

let s = 
rec {
   version = "1.7.7";
   name="directfb-${version}";
   sha256 = "18r7h0pwbyyk8z3pgdv77nmma8lvr1si9gl1ghxgxf1ivhwcd1dp";
   url="http://directfb.org/downloads/Core/DirectFB-1.7/DirectFB-${version}.tar.gz";
}
; in
stdenv.mkDerivation {
  inherit (s) name;
  src = fetchurl {
    inherit (s) url sha256;
  };

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ zlib libjpeg freetype giflib libpng ]
    ++ stdenv.lib.optional enableSDL SDL
    ++ stdenv.lib.optionals enableX11 (with xorg; [
      xorgproto libX11 libXext
      libXrender
    ]);

  NIX_LDFLAGS="-lgcc_s";

  configureFlags = [
    "--enable-sdl"
    "--enable-zlib"
    "--with-gfxdrivers=all"
    "--enable-devmem"
    "--enable-fbdev"
    "--enable-mmx"
    "--enable-sse"
    #"--enable-sysfs" # not recognized
    "--with-software"
    "--with-smooth-scaling"
    ] ++ stdenv.lib.optionals enableX11 [
      "--enable-x11"
    ];

  meta = with stdenv.lib; {
    description = "Graphics and input library designed with embedded systems in mind";
    longDescription = ''
      DirectFB is a thin library that provides hardware graphics acceleration,
      input device handling and abstraction, integrated windowing system with
      support for translucent windows and multiple display layers, not only on
      top of the Linux Framebuffer Device. It is a complete hardware
      abstraction layer with software fallbacks for every graphics operation
      that is not supported by the underlying hardware. DirectFB adds graphical
      power to embedded systems and sets a new standard for graphics under
      Linux.
    '';
    homepage = http://directfb.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
