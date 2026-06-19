{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderkittens";
  version = "0-unstable-2026-06-15";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "ThunderKittens";
    rev = "02e9acbd8c330564357a9e2df929e938ac67d6d0";
    hash = "sha256-GXrKCMKMDnQO7hNj4WZmmANSVJqEioIArwQWoE+/jVM=";
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
