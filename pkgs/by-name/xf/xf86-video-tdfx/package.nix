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
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-tdfx";
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-tdfx";
    tag = "xf86-video-tdfx-${finalAttrs.version}";
    hash = "sha256-95LFAPBT4nTuTLx83wsdOCwLOLed39WtP5FXPqiO/LI=";
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
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-tdfx-(.*)" ]; };
  };

  meta = {
    description = "3Dfx video driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-tdfx";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken =
      # configure: error: cannot check for file existence when cross compiling
      (stdenv.hostPlatform != stdenv.buildPlatform)
      # broken due to missing I/O Port syscalls
      || stdenv.hostPlatform.isAarch64;
  };
})
