{
  lib,
  fetchzip,
  buildGo124Module,
  nixosTests,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "traefik";
  version = "3.3.6";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-HA/JSwcss5ytGPqe2dqsKTZxuhWeC/yi8Mva4YVFeDs=";
    stripRoot = false;
  };

  vendorHash = "sha256-23BkkfJ6XLAygeeKipJk4puV5sGILb8rXEEA4qJWZS4=";

  subPackages = [ "cmd/traefik" ];

  env.CGO_ENABLED = 0;

  preBuild = ''
    GOOS= GOARCH= go generate

    CODENAME=$(grep -Po "CODENAME \?=\s\K.+$" Makefile)

    ldflags="-s"
    ldflags+=" -w"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Version=${version}"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Codename=$CODENAME"
  '';

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) traefik;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://traefik.io";
    description = "Modern reverse proxy";
    changelog = "https://github.com/traefik/traefik/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      djds
      vdemeester
    ];
    mainProgram = "traefik";
  };
}
