{
  lib,
  stdenv,
  fetchFromGitHub,
  rustc,
}:
stdenv.mkDerivation {
  pname = "ternimal";
  version = "0.1.0-unstable-2017-12-31";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "ternimal";
    rev = "e7953b4f80e514899e0920f0e36bb3141b685122";
    hash = "sha256-uIxuwRvStvlC/YiolOvWZd45Qg3b86jsZQ000zZMo3M=";
  };

  nativeBuildInputs = [ rustc ];

  buildPhase = ''
    runHook preBuild

    rustc -O $src/ternimal.rs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ternimal $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Simulate a lifeform in the terminal";
    homepage = "https://github.com/p-e-w/ternimal";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ anomalocaris ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "ternimal";
  };
}
