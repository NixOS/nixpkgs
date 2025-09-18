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
  version = "0-unstable-2025-09-11";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "4c9b8f6b7856de7e5598350424f243e6d17d73a6";
    hash = "sha256-8qxq9JR+w7Dy1Mm2Y1wKDuYzRwvo5ORNZ7vdJla51EI=";
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
