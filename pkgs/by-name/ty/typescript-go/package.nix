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
  version = "0-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "0a3c816da9be581f3b567df9f05b73533f5c9384";
    hash = "sha256-OAOQgHAojYadrv6bn2kXGHYisB928zW0c1g2Hx3jK50=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-w+v74GjOKyhBLj557m2yjgtCqcBOi+IKJ6kkI68AjKk=";

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
