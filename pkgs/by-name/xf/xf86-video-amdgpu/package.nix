{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libgbm,
  libGL,
  udev,
  xorgproto,
  xorg-server,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-amdgpu";
  version = "25.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-amdgpu";
    tag = "xf86-video-amdgpu-${finalAttrs.version}";
    hash = "sha256-7dLoKxBbE98FjADTYjjwj6OafJdecAkOCMRcYUYuYV4=";
  };

  patches = [
    # to fix https://github.com/NixOS/nixpkgs/issues/483585 aka https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/issues/8
    # apply patches from https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/merge_requests/76
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/commit/160879d7741e2d10e28920a3fedf04c44e35ebf2.patch";
      hash = "sha256-kOG1tq0Z5E5SawBATzyy09fOHlJO9CfW380BsSt+5ns=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/commit/dfe74c0d6fd8d31e14a057bcac821372adfb5b52.patch";
      hash = "sha256-0uRM/dmf1sWXvNsAVB+DLx+fEey1NP2UR5sOa/+eqKY=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdrm
    libgbm
    libGL
    udev
    xorgproto
    xorg-server
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=xf86-video-amdgpu-(.*)" ]; };
  };

  meta = {
    description = "Xorg driver for AMD Radeon GPUs using the amdgpu kernel driver";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu";
    license = with lib.licenses; [
      hpndSellVariant
      mit
      x11
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
