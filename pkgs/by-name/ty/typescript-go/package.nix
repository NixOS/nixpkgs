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
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "bd7c18dc8ed3c5ed960d72f1e329353f0a594bcc";
    hash = "sha256-RbLplpBIf7K576T6nN8EBr2TPoPuk8O9SbZ/VMHq3aw=";
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
