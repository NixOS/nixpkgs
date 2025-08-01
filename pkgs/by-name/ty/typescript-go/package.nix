{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "c05da65ec4298d5930c59b559e9d5e00dfab8af3";
    hash = "sha256-6zFBooMgdUHsKP5qOd7GOCBj3+NS0ckzWFIeO+0V2Fw=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-ORetO5VTo94KJfC/q7TDSWoQjZUKYjrMcSMecVpu8Pw=";

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
