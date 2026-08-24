{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-vmmouse";
  version = "13.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-vmmouse";
    tag = "xf86-input-vmmouse-${finalAttrs.version}";
    hash = "sha256-SasWsIzq9s8i3dabRwKGZ0NSuFqnUu4WCWYTu/ZZpS8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # xorg-server defines autoconf macros that we need
  ];

  buildInputs = [
    xorg-server
    xorgproto
    udev
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
    "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-input-vmmouse-(.*)" ]; };
  };

  meta = {
    description = "VMware guest mouse driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-input-vmmouse";
    license = with lib.licenses; [
      hpndSellVariant
      x11
    ];
    maintainers = [ ];
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
  };
})
