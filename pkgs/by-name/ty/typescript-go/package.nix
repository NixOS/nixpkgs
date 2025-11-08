{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
}:

let
  buildGoModule = buildGo125Module;
in
buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-11-04";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "3d247ef578b7291790fe059fc06a1ae9eaad9187";
    hash = "sha256-pfWeztSI41TTJ/oQwi6QX9Ow9nU3cXzv8Lq5TNn8Av0=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-ywhlLaUq2bjfE9GZIUOIcufIY1GLw3ZRGM+ZDfEpOiU=";

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
