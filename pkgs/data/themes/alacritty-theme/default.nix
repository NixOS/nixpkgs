{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  name = "alacritty-theme";
  version = "unstable-2024-02-28";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "4aefb7c079721474078b28bbf9f582b592749ca6";
    hash = "sha256-+35S6eQkxLBuS/fDKD5bglQDIuz2xeEc5KSaK6k7IjI=";
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
