{ stdenv, lib, fetchFromGitHub, fetchpatch
, autoreconfHook, perl, pkgconfig, flux, zlib
, libjpeg, freetype, libpng, giflib
, enableX11 ? true, xorg
, enableSDL ? true, SDL }:

stdenv.mkDerivation rec {
  pname = "directfb";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "deniskropp";
    repo = "DirectFB";
    rev = "DIRECTFB_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0bs3yzb7hy3mgydrj8ycg7pllrd2b6j0gxj596inyr7ihssr3i0y";
  };

  patches = [
    # Fixes build in "davinci" with glibc >= 2.28
    # The "davinci" module is only enabled on 32-bit arm.
    # https://github.com/deniskropp/DirectFB/pull/17
    (fetchpatch {
      url = "https://github.com/deniskropp/DirectFB/commit/3a236241bbec3f15b012b6f0dbe94353d8094557.patch";
      sha256 = "0rj3gv0zlb225sqjz04p4yagy4xacf3210aa8vra8i1f0fv0w4kw";
    })
  ];

  nativeBuildInputs = [ autoreconfHook perl pkgconfig flux ];

  buildInputs = [ zlib libjpeg freetype giflib libpng ]
    ++ lib.optional enableSDL SDL
    ++ lib.optionals enableX11 (with xorg; [
      xorgproto libX11 libXext
      libXrender
    ]);

  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = [
    "--enable-sdl"
    "--enable-zlib"
    "--with-gfxdrivers=all"
    "--enable-devmem"
    "--enable-fbdev"
    "--enable-mmx"
    "--enable-sse"
    "--with-software"
    "--with-smooth-scaling"
  ] ++ lib.optional enableX11 "--enable-x11";

  meta = with lib; {
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
    homepage = "https://github.com/deniskropp/DirectFB";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
