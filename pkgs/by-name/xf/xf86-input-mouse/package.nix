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
  pname = "xf86-input-mouse";
  version = "1.9.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-mouse";
    tag = "xf86-input-mouse-${finalAttrs.version}";
    hash = "sha256-vxdzLn9sclIYmPKw7vRa4oQJYmQV98WMfIjkMRosr/w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorgproto
    xorg-server
  ];

  configureFlags = [ "--with-sdkdir=${placeholder "out"}/include/xorg" ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-mouse-(.*)" ]; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Mouse input driver for non-Linux platforms for the Xorg X server";
    longDescription = ''
      This driver is used on non-Linux operating systems such as BSD & Solaris, as modern Linux
      systems use the xf86-input-evdev or xf86-input-libinput drivers instead.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-mouse";
    license = with lib.licenses; [
      mit
      hpndSellVariant
      x11
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xorg-mouse" ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputmouse.x86_64-darwin
  };
})
