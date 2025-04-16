{
  lib,
  fetchzip,
  buildGo123Module,
  nixosTests,
}:

buildGo123Module rec {
  pname = "traefik";
  version = "3.3.4";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-KXFpdk1VMYzGldFp/b5Ss6aJvL9yG4kSbM4LOIBUL5A=";
    stripRoot = false;
  };

  vendorHash = "sha256-wtZFViVNvNuhHvI1YR2ome1rs2DIAd3Iurmpi9Y6F2w=";

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
