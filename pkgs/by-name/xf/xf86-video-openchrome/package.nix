{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  util-macros,
  libdrm,
  libpciaccess,
  libx11,
  libxext,
  libxv,
  libxvmc,
  udev,
  xorgproto,
  xorg-server,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-openchrome";
  version = "0.6.225";

  src = fetchgit {
    url = "https://anongit.freedesktop.org/git/openchrome/xf86-video-openchrome.git";
    # release is unfortunately not tagged so also no automatic updates
    rev = "ab03de703b91c7e0fd3e4d1ca06ad5add7f077a1";
    hash = "sha256-Aa0Mhb6miSakAEZKCZ5/+n9oyCp4y4srq9ljRNqP7F4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    libdrm
    libpciaccess
    libx11
    libxext
    libxv
    libxvmc
    xorgproto
    xorg-server
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  meta = {
    description = "VIA Technologies UniChrome and Chrome9 IGP video driver for the Xorg X server";
    longDescription = ''
      OpenChrome DDX is an open source implementation of X.Org Server DDX (Device Dependent X)
      graphics device driver for VIA Technologies UniChrome and Chrome9 IGPs. (Integrated Graphics
      Processor) OpenChrome DDX handles only 2D and video acceleration.
    '';
    homepage = "http://www.freedesktop.org/wiki/Openchrome";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
})
