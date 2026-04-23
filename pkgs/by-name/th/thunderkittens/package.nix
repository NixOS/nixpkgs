{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderkittens";
  version = "0-unstable-2026-04-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "ThunderKittens";
    rev = "0a3ce9a949fb520ba10cda09cb5ffad7f6a1cc0a";
    hash = "sha256-Wk3oafjEkTddn/880dHAg8S7EUDuEbXYnW0dmPTC54g=";
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
