{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

let
  buildGoModule = buildGo126Module;
in
buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "737e16fee4eedc201b8c70109bef965b4c73c23c";
    hash = "sha256-YSg/stB9my8KAEOkS2hvlVJ56EFmHSpC492+AY5YmOE=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-Il2UgZ1DX0ijKZLlMNOdywOANBl9x5WSLiQbp3gogBQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    version="$("$out/bin/tsgo" --version)"
    [[ "$version" == *"7.0.0"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Go implementation of TypeScript";
    homepage = "https://github.com/microsoft/typescript-go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsgo";
  };
}
