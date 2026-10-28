{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-v4l";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-v4l";
    tag = "xf86-video-v4l-${finalAttrs.version}";
    hash = "sha256-uCKeecAqHycYduKaDVMupGvMN84vHeF3ECyVchkXwdA=";
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
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-v4l-(.*)" ]; };
  };

  meta = {
    description = "Video 4 Linux adaptor driver for the Xorg X server";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-v4l";
    license = with lib.licenses; [
      # MIT AND X11 AND (GPL-2.0-or-later OR BSD-3-Clause)
      mit
      x11
      gpl2Plus
      bsd3
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
