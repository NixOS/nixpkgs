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
  version = "0-unstable-2025-10-03";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "e729a0a55aa898cd3ce424a5c97e07f5dc98580f";
    hash = "sha256-ZIluvlQNC21EZA4le+lyeynaJj4D0JYxI9njgw7Uuyc=";
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
