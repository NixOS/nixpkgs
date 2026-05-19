{
  lib,
  fetchzip,
  buildGo125Module,
  nixosTests,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "traefik";
  version = "3.6.17";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${finalAttrs.version}/traefik-v${finalAttrs.version}.src.tar.gz";
    hash = "sha256-Tqm8Fb+3X/I3v1PG5qfgFMnhbBjKJ5i+3qfd7YuRzFI=";
    stripRoot = false;
  };

  vendorHash = "sha256-k61m/fnyA9GH57BsylqhUoRao+ujqyDdho9HQNICbhs=";

  proxyVendor = true;

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
