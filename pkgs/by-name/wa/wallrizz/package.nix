{
  lib,
  stdenv,
  fetchFromGitHub,
  quickjs,
  versionCheckHook,
  nix-update-script,
}:

let
  qjsExtLib = fetchFromGitHub {
    owner = "ctn-malone";
    repo = "qjs-ext-lib";
    tag = "0.16.1";
    hash = "sha256-oq8MFXo2grwz11Tv7HMetwYKOpbgMmeqxd1caFBi57U=";
  };
  justjs-scripts = fetchFromGitHub {
    owner = "5hubham5ingh";
    repo = "justjs";
    rev = "10b0c16e5d01ff0d1560d412cd1c19146d45a984";
    hash = "sha256-FWIS6f16wIvTgpEUxhCeYL94Jp8b19X4Nx6oww7sbU0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wallrizz";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "5hubham5ingh";
    repo = "WallRizz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3dulDrbvAvwgeDlDt7um2qmZOkBkd5alaq8hyfgGfQ=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    quickjs
  ];

  preConfigure = ''
    cp -r ${qjsExtLib} ../../qjs-ext-lib
    cp -r ${justjs-scripts} ../../justjs
  '';

  buildPhase = ''
    runHook preBuild

    qjsc -flto -D extensionHandlerWorker.js -o WallRizz main.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 WallRizz $out/bin/wallrizz

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal based wallpaper and system theme manager";
    longDescription = "A terminal-based wallpaper manager that displays wallpapers in a grid, allowing users to select and set wallpapers while automatically customizing application color themes based on the chosen wallpaper. It also enables browsing and downloading wallpapers from a GitHub repository.";
    mainProgram = "wallrizz";
    homepage = "https://github.com/5hubham5ingh/wallrizz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qweered ];
  };
})
