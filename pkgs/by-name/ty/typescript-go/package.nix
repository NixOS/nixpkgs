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
  version = "0-unstable-2025-12-06";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "1d138eaa29bc189e6b4f04b87fe278b6afe7e62f";
    hash = "sha256-CNVKfWvlRzKPm3WSFxT7te5gd5TfErApseUfrqcwUQU=";
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
