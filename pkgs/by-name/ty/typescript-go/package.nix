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
  version = "0-unstable-2025-10-11";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "a05e479428cb43c6228f78dc04f8326bbd91317b";
    hash = "sha256-ypn+DCfSfASgigjer0n65qGx0DGZzflTyinITgGbdeU=";
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
