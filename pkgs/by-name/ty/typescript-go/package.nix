{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "644bde28939733580cbef96adaa7253f9faa54ac";
    hash = "sha256-5oU3tTZ8jvc85jzgh14ICLlz0VgQ7v2ofeMADRMW5O4=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-nOro2EARm/4LZ0BfX10nuhCAlPi6T91EpXGP0F9Rm04=";

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
