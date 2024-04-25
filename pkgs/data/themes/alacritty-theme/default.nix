{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  name = "alacritty-theme";
  version = "yaml-unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "e866efd4ac4e1b4b05892bf9f9bae0540754bca3";
    hash = "sha256-Uv/Nv2aipnMBM7F4IoUiLF4U/27SF9H/EEfnwGfjiIs=";
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
