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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-dummy";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-dummy";
    tag = "xf86-video-dummy-${finalAttrs.version}";
    hash = "sha256-lEqA716pg1mjTLEkHLITXJMZY9Vj8VByEs49ONNxpHs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    xorg-server # for some autoconf macros
  ];

  buildInputs = [
    xorgproto
    xorg-server
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-dummy-(.*)" ]; };
  };

  meta = {
    description = "Virtual/offscreen frame buffer driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-dummy";
    # dummy driver was imported from XFree86 which was under the x11 license
    license = lib.licenses.x11;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
