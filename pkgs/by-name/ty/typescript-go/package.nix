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
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "1611cc951fa772cfca09c38fe2d981f6da5d20b8";
    hash = "sha256-lFyHFg6u0G6E5fEOYt/N55LrLOHDCiZ6OA+NAZABkGE=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-1uZemqPsDxiYRVjLlC/UUP4ZXVCjocIBCj9uCzQHmog=";

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
