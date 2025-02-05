{
  lib,
  fetchzip,
  buildGo123Module,
  nixosTests,
}:

buildGo123Module rec {
  pname = "traefik";
  version = "3.3.3";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-R9fiCLqzrd9SS6LoQt3jOoEchRnPuhmJqIob8JhzqEU=";
    stripRoot = false;
  };

  vendorHash = "sha256-9WuhQjl+lWRZBvEP8qjBQUbEQC1SG9J+3xNpmIieOo8=";

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
