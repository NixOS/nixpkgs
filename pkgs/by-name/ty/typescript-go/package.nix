{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-07-08";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "bc8d29cb2f6248c9f6fbbc9a7625634c070b8f67";
    hash = "sha256-XpqQxL2aC0xfRVrPAj7gERIHI1Po3d5DGOrY9raNB14=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-9gZ1h/rsJ5DEcU8CJGKszE98GzZqfs2ELp1lbXsliYk=";

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
