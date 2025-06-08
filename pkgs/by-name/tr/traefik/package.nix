{
  lib,
  fetchzip,
  buildGo124Module,
  nixosTests,
  nix-update-script,
}:

buildGo124Module (finalAttrs: {
  pname = "traefik";
  version = "3.4.1";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${finalAttrs.version}/traefik-v${finalAttrs.version}.src.tar.gz";
    hash = "sha256-cE4Pivu1wUZqd1i+aYZqirNQse1ExgEV6550CawRwJM=";
    stripRoot = false;
  };

  vendorHash = "sha256-eaeuTYjwv4Pa48YZ2yDOIRDRrSSw6fNhJIN8imV5dNM=";

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
