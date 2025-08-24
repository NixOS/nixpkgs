{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "1ee2ba99609ae66af1e7ec4a4770482d7eeaeb43";
    hash = "sha256-5xSQaQ1ntFmwLzdkqEi9GORRJ9bYHsTCW+3JAi76Fh0=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-w+v74GjOKyhBLj557m2yjgtCqcBOi+IKJ6kkI68AjKk=";

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
