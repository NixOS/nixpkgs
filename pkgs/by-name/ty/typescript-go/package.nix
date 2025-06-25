{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "f7d02dd5cc61be86f4f61018171c370cefebe3fd";
    hash = "sha256-19+t/Yq73Ih8yCoMJe4r65iejOeAeKYEWacMzqGs6jQ=";
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
