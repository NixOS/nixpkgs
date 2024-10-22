{
  fetchFromGitHub,
  lib,
  stdenv,
  libX11,
  libxcb,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsie";
  version = "4.16.1";

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9G+2yYc5Lcmw5NvLnn7jVZ4Fw79L29KbhiE2CYh6SLM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildInputs = [
    libX11
    libxcb
    qt5.qtwebengine
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  strictDeps = false;

  enableParallelBuilding = true;

  preBuild = ''
    export QT_WEBENGINE_ICU_DATA_DIR=${qt5.qtwebengine.out}/resources
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 whatsie -t $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/keshavbhatt/whatsie";
    description = "Feature rich WhatsApp Client for Desktop Linux";
    license = lib.licenses.mit;
    mainProgram = "whatsie";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
})
