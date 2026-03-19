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
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "737e16fee4eedc201b8c70109bef965b4c73c23c";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-QNKXJ9HA8WlLlTxflLt0a/Y2Lt8NG1AnNmBOESYFyRI=";

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
