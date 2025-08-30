{
  lib,
  stdenv,
  fetchFromGitHub,
  quickjs,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.0";
  pname = "wallrizz";

  src = fetchFromGitHub {
    owner = "5hubham5ingh";
    repo = "WallRizz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6O+GXx/BYRxVKsxdE0rp0AH4awbYa5lNalrPduksOuU=";
  };

  qjsExtLib = fetchFromGitHub {
    owner = "ctn-malone";
    repo = "qjs-ext-lib";
    tag = "0.14.2";
    hash = "sha256-amfxPwTMJaAOQSn0EFd9yqer+Y72Gg/wQlMBoCs0u4U=";
  };

  justjs = fetchFromGitHub {
    owner = "5hubham5ingh";
    repo = "justjs";
    tag = "main";
    hash = "sha256-Y7l/AwQBYmZ7aLwWKj2Z5Afd8XPez8EM68PSZL3JiUc=";
  };

  buildInputs = [
    quickjs
  ];

  buildPhase = ''
    runHook preBuild

    # Copy dependencies to expected locations (JavaScript imports expect ../../qjs-ext-lib and ../../justjs)
    cp -r ${finalAttrs.qjsExtLib} ../qjs-ext-lib
    cp -r ${finalAttrs.justjs} ../justjs

    # Build in src directory
    cd src
    qjsc -flto -D extensionHandlerWorker.js -o WallRizz main.js
    cp WallRizz ../

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install the binary (copied from src/ during build)
    install -Dm755 WallRizz $out/bin/wallrizz

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "A terminal-based wallpaper manager that displays wallpapers in a grid, allowing users to select and set wallpapers while automatically customizing application color themes based on the chosen wallpaper. It also enables browsing and downloading wallpapers from a GitHub repository.";
    mainProgram = "wallrizz";
    homepage = "https://github.com/5hubham5ingh/wallrizz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qweered ];
    platforms = lib.platforms.linux;
  };
})
