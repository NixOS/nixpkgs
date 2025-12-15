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
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "2046634603b3283c38b31489e5e4d81a013832a0";
    hash = "sha256-F5CCz5IDNe0mhofh7JPmmUwGzasUrTUDQLClybfsBxc=";
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
