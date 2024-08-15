{ lib
, stdenv
, fetchFromGitHub
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
, xcbutilimage
, xkbcomp
, xkeyboard_config
, xorgproto
, xtrans
, unstableGitUpdater
}:

stdenv.mkDerivation (finalPackages: {
  pname = "xarcan";
  version = "0-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "xarcan";
    rev = "7644616b3bd0ff2b5708e93acc990cd757b20ae9";
    hash = "sha256-iKYTuJ/1iwm449ZOBOzi+LkrTTio7aaIHUn+M+Sbzc8=";
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
    xcbutilimage
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

  passthru.updateScript = unstableGitUpdater {};

  meta =  {
    homepage = "https://github.com/letoram/letoram";
    description = "Patched Xserver that bridges connections to Arcan";
    mainProgram = "Xarcan";
    longDescription = ''
      xarcan is a patched X server with a KDrive backend that uses the
      arcan-shmif to map Xlib/Xcb/X clients to a running arcan instance. It
      allows running an X session as a window under Arcan.
    '';
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
