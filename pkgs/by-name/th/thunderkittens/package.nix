{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderkittens";
  version = "0-unstable-2026-05-27";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "ThunderKittens";
    rev = "34b15f7e7012de25ae162c8d9dc85296dd342676";
    hash = "sha256-VN6AACu6LqOuCCvpNOeGGdYkQblxyWolBnCNeSxgiL4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r include/* $out/include/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Tile primitives for speedy CUDA deep learning kernels";
    homepage = "https://github.com/HazyResearch/ThunderKittens";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
