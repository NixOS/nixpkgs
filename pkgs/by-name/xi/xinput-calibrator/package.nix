{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  pkg-config,
  meson,
  ninja,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xinput-calibrator";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg/app";
    repo = "xinput-calibrator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BxLBLv6g3hfj2ydIliZitGK/oYepvz1LYknvSWnNG58=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXi
    xorg.libXrandr
  ];

  meta = {
    homepage = "https://gitlab.freedesktop.org/xorg/app/xinput-calibrator";
    description = "Generic touchscreen calibration program for X.Org";
    license = with lib.licenses; [
      cc-by-sa-30 # icon
      mit
    ];
    maintainers = [ lib.maintainers.flosse ];
    platforms = lib.platforms.linux;
    mainProgram = "xinput_calibrator";
  };
})
