{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  libevdev,
  udev,
  mtdev,
  xorg-server,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-evdev";
  version = "2.11.0";

  # to get rid of xorg-server.dev; man is tiny
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-evdev";
    tag = "xf86-input-evdev-${finalAttrs.version}";
    hash = "sha256-tXB50laCJcLoBbwM/hE+qEiHzmN7Q+r8uu6NPlRmpTM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorgproto
    libevdev
    udev
    mtdev
    xorg-server
  ];

  configureFlags = [
    "--with-sdkdir=${placeholder "dev"}/include/xorg"
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-evdev-(.*)" ]; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Generic Linux input driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-evdev";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xorg-evdev" ];
    platforms = lib.platforms.unix;
  };
})
