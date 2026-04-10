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
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "08cb84c68ae83b9def5e0132e05362e5061342ab";
    hash = "sha256-IvR7zHSl7kUmamQkGGrzdKJrdypnQe2a0X1YUyRYYTU=";
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
