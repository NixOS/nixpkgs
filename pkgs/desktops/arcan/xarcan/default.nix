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
  version = "0.6.0+unstable=2021-06-14";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "98d28a5f2c6860bb191fbc1c9e577c18e4c9a9b7";
    hash = "sha256-UTIVDKnYD/q0K6G7NJUKh1tHcqnsuiJ/cQxWuPMJ2G4=";
  };

  patches = [
    # fix build with meson 0.60
    (fetchpatch {
      url = "https://github.com/letoram/xarcan/commit/b67e514dbb59bffc23b75d47ca7f24e96c4aeb05.patch";
      sha256 = "sha256-tSQmNy1Id6nDIN+03dc1+rEEF8fMq0yJBiscNM60xic=";
    })
  ];

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
    platforms = platforms.all;
  };
}
