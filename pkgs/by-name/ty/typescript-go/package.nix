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
  version = "0-unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "20b1482ea8b55d51fc21c60718dc934d763c918b";
    hash = "sha256-+sfewMFnvq4zJO6KCvii9qF8LdAd+5Rqk2GJcJrJAeI=";
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
