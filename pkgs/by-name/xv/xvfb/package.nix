# xvfb is used by a bunch of things to run tests
# so try to reduce its reverse closure
{
  lib,
  stdenv,
  pkg-config,
  xorg-server,
  dri-pkgconfig-stub,
  libdrm,
  libGL,
  libX11,
  libXau,
  libxcb,
  libxcvt,
  libxdmcp,
  libxfixes,
  libxfont_2,
  libxkbfile,
  libxshmfence,
  mesa-gl-headers,
  openssl,
  pixman,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  xkbcomp,
  xkeyboardconfig,
  xorgproto,
  xtrans,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xvfb";

  inherit (xorg-server) src version;

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dri-pkgconfig-stub
    libdrm
    libGL
    libX11
    libXau
    libxcb
    libxcvt
    libxdmcp
    libxfixes
    libxfont_2
    libxkbfile
    libxshmfence
    mesa-gl-headers
    openssl
    pixman
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    xorgproto
    xtrans
  ];

  configureFlags = [
    "--enable-xvfb"
    "--disable-xorg"
    "--disable-xquartz"
    "--disable-xwayland"
    "--with-xkb-bin-directory=${xkbcomp}/bin"
    "--with-xkb-path=${xkeyboardconfig}/share/X11/xkb"
    "--with-xkb-output=$out/share/X11/xkb/compiled"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--without-dtrace";

  meta = {
    description = "X virtual framebuffer";
    longDescription = ''
      Xvfb or X virtual framebuffer is a display server implementing the X11 display server
      protocol. In contrast to other display servers, Xvfb performs all graphical operations in
      virtual memory without showing any screen output. From the point of view of the X client app,
      it acts exactly like any other X display server, serving requests and sending events and
      errors as appropriate. However, no output is shown. This virtual server does not require the
      computer it is running on to have any kind of graphics adapter, a screen or any input device.
      Is is primarily used for testing.
    '';
    inherit (xorg-server.meta)
      homepage
      license
      mainProgram
      ;
    platforms = lib.platforms.unix;
  };
})
