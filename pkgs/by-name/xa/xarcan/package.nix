{
  lib,
  stdenv,
  fetchFromCodeberg,
  arcan,
  audit,
  dbus,
  dri-pkgconfig-stub,
  libepoxy,
  fontutil,
  libGL,
  libX11,
  libXau,
  libXdmcp,
  libXfont2,
  libdrm,
  libgcrypt,
  libmd,
  libselinux,
  libtirpc,
  libxcb,
  libxkbfile,
  libxshmfence,
  libgbm,
  mesa-gl-headers,
  meson,
  nettle,
  ninja,
  openssl,
  pixman,
  pkg-config,
  systemd,
  xcbutil,
  xcbutilwm,
  xcbutilimage,
  xkbcomp,
  xkeyboard_config,
  xorgproto,
  xtrans,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalPackages: rec {
  pname = "xarcan";
  version = "0.7.1";

  src = fetchFromCodeberg {
    owner = "letoram";
    repo = "xarcan";
    tag = version;
    hash = "sha256-j20Wz/Ae4QTincAPgMoj19EfKAPxIGm0Jgmi4sUR88o=";
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
    dri-pkgconfig-stub
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
    libgbm
    mesa-gl-headers
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://codeberg.org/letoram/xarcan";
    description = "Patched Xserver that bridges connections to Arcan";
    mainProgram = "Xarcan";
    longDescription = ''
      xarcan is a patched X server with a KDrive backend that uses the
      arcan-shmif to map Xlib/Xcb/X clients to a running arcan instance. It
      allows running an X session as a window under Arcan.
    '';
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
