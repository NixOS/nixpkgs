{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  name = "alacritty-theme";
  version = "unstable-2023-10-12";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "4cb179606c3dfc7501b32b6f011f9549cee949d3";
    hash = "sha256-Ipe6LHr83oBdBMV3u4xrd+4zudHXiRBamUa/cOuHleY=";
  };

  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;

  sourceRoot = "${self.src.name}/themes";
  installPhase = ''
    runHook preInstall
    install -Dt $out *.yaml
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Collection of Alacritty color schemes";
    homepage = "https://alacritty.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.nicoo ];
    platforms = platforms.all;
  };
})
