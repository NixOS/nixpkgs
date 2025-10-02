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
  version = "0-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "1ca5a2d97b0c2b93cfc32137c8922185b4f41df0";
    hash = "sha256-g1Wc2jAlpO7voqIFvNkEF900ZZIb/nwNFL1+4ZUGU9U=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-k1fKa93zxMnORDPWnZrMahNHG0sCa3JOJl+d4T8PyIM=";

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
