{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderkittens";
  version = "0-unstable-2026-08-27";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "ThunderKittens";
    rev = "be0e7e57e90858dfa2bbeab7296ff252755f8a37";
    hash = "sha256-W/FfJlO0wiGYfdNC5Ef/ipRq7n5SIjnN5eF5YGf6hTQ=";
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
