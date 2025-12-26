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
  udev,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nouveau";
  version = "1.0.18";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = finalAttrs.pname;
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-y9fQpMg6qKjaQvDfqYbWscFomtzmHQ1cvzMaa4anhOE=";
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
    udev
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=${finalAttrs.pname}-(.*)" ]; };
  };

  meta = {
    description = "Xorg X server driver for NVIDIA video cards";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau";
    license = [
      # TODO: Gather all copying information and replace stub copying file
      # upstream, then add licensing info here.
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
