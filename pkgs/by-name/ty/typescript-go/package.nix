{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "1b88303de8ad861566d479b0bcf5b88874494536";
    hash = "sha256-qxP8MhUK9ww3yB0ko2K6GPUfY1bcfGL3u5qRACf9ZK0=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-SoBlxQfMg59UOO+99HPeKqEPxD2p7JauLMTpQ7Jl03s=";

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
    updateScript = unstableGitUpdater { };
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
