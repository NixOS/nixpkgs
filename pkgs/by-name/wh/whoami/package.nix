{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whoami";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "whoami";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jzLdCmmts/7S1Oxig9Dg3kRGh/H5l5UD7ztev0yvXY=";
  };

  vendorHash = "sha256-0Qxw+MUYVgzgWB8vi3HBYtVXSq/btfh4ZfV/m1chNrA=";

  ldflags = [ "-s" ];

  env.CGO_ENABLED = 0;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/whoami --help 2> /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) whoami; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tiny Go server that prints os information and HTTP request to output";
    mainProgram = "whoami";
    homepage = "https://github.com/traefik/whoami";
    changelog = "https://github.com/traefik/whoami/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dvcorreia
      defelo
    ];
  };
})
