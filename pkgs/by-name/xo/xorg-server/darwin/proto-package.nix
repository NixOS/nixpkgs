{
  lib,
  stdenv,
  xorg-server,
  pkg-config,
  libx11,
  libxau,
  libxcb,
  libxdmcp,
  libxfixes,
  libxkbfile,
  openssl,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  xorgproto,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (xorg-server) pname version src;

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxau
    libxcb
    libxdmcp
    libxfixes
    libxkbfile
    openssl
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    xorgproto
  ];

  configureFlags = [
    "--disable-xquartz"
    "--enable-xorg"
    "--enable-xvfb"
    "--enable-xnest"
    "--enable-kdrive"
  ];

  meta = xorg-server.meta // {
    platforms = lib.platforms.darwin;
  };
})
