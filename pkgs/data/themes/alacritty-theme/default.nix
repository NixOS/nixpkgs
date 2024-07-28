{ lib
, fetchFromGitHub
, unstableGitUpdater
, stdenvNoCC
, ... }:

stdenvNoCC.mkDerivation (self: {
  pname = "alacritty-theme";
  version = "0-unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "bcc5ec1bdecb4a799a6bc8ad3a5b206b3058d6df";
    hash = "sha256-IRAUY/59InKYLRfMYI78wSKC6+KI/7aOtOhQNUqdjOA=";
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

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Collection of Alacritty color schemes";
    homepage = "https://alacritty.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.nicoo ];
    platforms = platforms.all;
  };
})
