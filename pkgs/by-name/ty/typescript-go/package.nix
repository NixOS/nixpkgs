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
  version = "0-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "ea6a3dc055cfcac80fecf12264b01d62bfd7a094";
    hash = "sha256-gn46RcWqXor7yyMhG/TH3DwzTAko/5kST65iZ32vqgg=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-1QEwrFS4Qesp2CwzcsuMP8mLQlXKzfNaM9PFMEfDYxk=";

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
