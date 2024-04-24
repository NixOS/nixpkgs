{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  name = "alacritty-theme";
  version = "unstable-2024-03-06";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "cb786242b6f5e00a57e2f541e7bf1115f3950650";
    hash = "sha256-fZJ0F4zJy6HOwWtZGm5yN4WfeFNJnW/UJhoQSZ0Bpxk=";
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
