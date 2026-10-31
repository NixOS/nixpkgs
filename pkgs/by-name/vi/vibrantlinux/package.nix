{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libvibrant,
  libxcb,
  libxrandr,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vibrantLinux";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libvibrant";
    repo = "vibrantLinux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GsGWQ6Os8GQ1XbRKrlTOpwPvwyfT/6ftjlt+fJ/YiK8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libvibrant
    libxcb
    libxrandr
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    description = "Tool to automate managing your screen's saturation depending on what programs are running";
    homepage = "https://github.com/libvibrant/vibrantLinux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Scrumplex
      unclamped
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vibrantLinux";
  };
})
