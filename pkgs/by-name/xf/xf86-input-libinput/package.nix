{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  libinput,
  xorg-server,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-libinput";
  version = "1.5.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-libinput";
    tag = "xf86-input-libinput-${finalAttrs.version}";
    hash = "sha256-yZi5h3k6cwunucLhmH/wNchA0M11U3KBwrRuY/oATh8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorgproto
    libinput
    xorg-server
  ];

  configureFlags = [
    "--with-sdkdir=${placeholder "dev"}/include/xorg"
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-libinput-(.*)" ]; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "libinput-based input driver for the Xorg X server";
    longDescription = ''
      This is an X driver based on libinput. It is a thin wrapper around libinput, so while it does
      provide all features that libinput supports it does little beyond.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-libinput";
    license = lib.licenses.mit;
    maintainers = [ ];
    pkgConfigModules = [ "xorg-libinput" ];
    platforms = lib.platforms.unix;
  };
})
