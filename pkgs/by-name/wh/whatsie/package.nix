{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  libx11,
  libxcb,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsie";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GVXwZZFfPqAmBrP95zleHc2PpMMBj/8xZdW4JpFdYVs=";
  };

  buildInputs = [
    libx11
    libxcb
    qt6.qtwebengine
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/keshavbhatt/whatsie";
    description = "Feature rich WhatsApp Client for Desktop Linux";
    license = lib.licenses.mit;
    mainProgram = "whatsie";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
})
