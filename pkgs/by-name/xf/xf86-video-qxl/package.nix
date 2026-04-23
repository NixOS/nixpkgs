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
  spice-protocol,
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-qxl";
  version = "0.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-qxl";
    tag = "xf86-video-qxl-${finalAttrs.version}";
    hash = "sha256-g7NvAjmvPjyqUTXnZREDDs18O2e9Zl5hZeAza2a/1Jw=";
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
    spice-protocol
    udev
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-qxl-(.*)" ]; };
  };

  meta = {
    description = "Xorg video driver for the QXL virtual GPU";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-qxl";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
})
