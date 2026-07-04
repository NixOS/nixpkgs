{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorg-server,
  xorgproto,
  libpciaccess,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-vbox";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-vbox";
    tag = "xf86-video-vboxvideo-${finalAttrs.version}";
    hash = "sha256-C+5spc9EABu3p5Ck7R4bWedLDm8h0DrbYic2AwIUAqU=";
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
    libpciaccess
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-vboxvideo-(.*)" ]; };
  };

  meta = {
    description = "VirtualBox video driver for the Xorg X server";
    longDescription = ''
      This driver is only for use in VirtualBox guests without the vboxvideo kernel modesetting
      driver in the guest kernel, and which are configured to use the VBoxVGA device instead of a
      VMWare-compatible video device emulation.
      Guests with the vboxvideo kernel modesetting driver should use the Xorg "modesetting" driver
      module instead of this one.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-vbox";
    license = with lib.licenses; [
      mit
      x11
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
})
