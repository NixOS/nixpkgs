{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, arcan
, audit
, dbus
, libepoxy
, fontutil
, libGL
, libX11
, libXau
, libXdmcp
, libXfont2
, libdrm
, libgcrypt
, libmd
, libselinux
, libtirpc
, libxcb
, libxkbfile
, libxshmfence
, mesa
, meson
, nettle
, ninja
, openssl
, pixman
, pkg-config
, systemd
, xcbutil
, xcbutilwm
, xkbcomp
, xkeyboard_config
, xorgproto
, xtrans
}:

stdenv.mkDerivation rec {
  pname = "xarcan";
  version = "0.6.0+date=2021-08-26";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "e40f0176e495ffdad6e7405c58378df6532eb70d";
    hash = "sha256-T+1oL7P5MTDkeSfW6OXc1OgfZ8E6e/4YRonf1eXcfIA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    arcan
    audit
    dbus
    libepoxy
    fontutil
    libGL
    libX11
    libXau
    libXdmcp
    libXfont2
    libdrm
    libgcrypt
    libmd
    libselinux
    libtirpc
    libxcb
    libxkbfile
    libxshmfence
    mesa
    nettle
    openssl
    pixman
    systemd
    xcbutil
    xcbutilwm
    xkbcomp
    xkeyboard_config
    xorgproto
    xtrans
  ];

  configureFlags = [
    "--disable-int10-module"
    "--disable-static"
    "--disable-xnest"
    "--disable-xorg"
    "--disable-xvfb"
    "--disable-xwayland"
    "--enable-glamor"
    "--enable-glx"
    "--enable-ipv6"
    "--enable-kdrive"
    "--enable-record"
    "--enable-xarcan"
    "--enable-xcsecurity"
    "--with-xkb-bin-directory=${xkbcomp}/bin"
    "--with-xkb-output=/tmp"
    "--with-xkb-path=${xkeyboard_config}/share/X11/xkb"
  ];

  meta = with lib; {
    homepage = "https://github.com/letoram/letoram";
    description = "Patched Xserver that bridges connections to Arcan";
    longDescription = ''
      xarcan is a patched X server with a KDrive backend that uses the
      arcan-shmif to map Xlib/Xcb/X clients to a running arcan instance. It
      allows running an X session as a window under Arcan.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
