{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  name = "alacritty-theme";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "f03686afad05274f5fbd2507f85f95b1a6542df4";
    hash = "sha256-457kKE3I4zGf1EKkEoyZu0Fa/1O3yiryzHVEw2rNZt8=";
  };

  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;

  sourceRoot = "${self.src.name}/themes";
  installPhase = ''
    runHook preInstall
    install -Dt $out *.toml
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
