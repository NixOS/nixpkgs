{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  libdrm,
  libpciaccess,
  libx11,
  libxext,
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-vmware";
  version = "13.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-vmware";
    tag = "xf86-video-vmware-${finalAttrs.version}";
    hash = "sha256-aC/LsAvrVtG+2SrMaB7ROJTUIleZTcLydmt5cQf0dHc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # for some autoconf macros
  ];

  buildInputs = [
    xorg-server
    xorgproto
    libdrm
    libpciaccess
    libx11
    libxext
    udev
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=address"; # gcc12

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=xf86-video-vmware-(.*)" ];
  };

  meta = {
    description = "VMware guest video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-vmware";
    license = with lib.licenses; [
      x11
      mit
    ];
    maintainers = [ ];
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
  };
})
