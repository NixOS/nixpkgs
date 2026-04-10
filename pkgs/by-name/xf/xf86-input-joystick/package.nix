{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  xorg-server,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-joystick";
  version = "1.6.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-joystick";
    tag = "xf86-input-joystick-${finalAttrs.version}";
    hash = "sha256-JxSnhWx5V3/pdlu3mwRNrgicdfaUK5nIwBK3reqchQs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # xorg-server defines autoconf macros that we need
  ];

  buildInputs = [
    util-macros # unused dependency but the build fails if pkg-config can't find it
    xorgproto
    xorg-server
  ];

  configureFlags = [ "--with-sdkdir=${placeholder "out"}/include/xorg" ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-joystick-(.*)" ]; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Joystick input driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-joystick";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xorg-joystick" ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xf86-input-joystick.x86_64-darwin
  };
})
