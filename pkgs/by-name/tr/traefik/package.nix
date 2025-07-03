{
  lib,
  fetchzip,
  buildGo124Module,
  nixosTests,
  nix-update-script,
}:

buildGo124Module (finalAttrs: {
  pname = "traefik";
  version = "3.4.3";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${finalAttrs.version}/traefik-v${finalAttrs.version}.src.tar.gz";
    hash = "sha256-fxFr0PRKMYf5KpyFUoEv4TEJBmwTr1s5CRAZyHAgfqM=";
    stripRoot = false;
  };

  vendorHash = "sha256-nh5l71iRnT32mceeS7slksP3hjQP4hO4AKIvlO+CYMQ=";

  subPackages = [ "cmd/traefik" ];

  env.CGO_ENABLED = 0;

  preBuild = ''
    GOOS= GOARCH= go generate

    CODENAME=$(grep -Po "CODENAME \?=\s\K.+$" Makefile)

    ldflags="-s"
    ldflags+=" -w"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major finalAttrs.version}/pkg/version.Version=${finalAttrs.version}"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major finalAttrs.version}/pkg/version.Codename=$CODENAME"
  '';

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) traefik;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://traefik.io";
    description = "Modern reverse proxy";
    changelog = "https://github.com/traefik/traefik/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djds
      vdemeester
    ];
    mainProgram = "traefik";
  };
})
