{
  lib,
  fetchzip,
  buildGo125Module,
  nixosTests,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "traefik";
  version = "3.6.10";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${finalAttrs.version}/traefik-v${finalAttrs.version}.src.tar.gz";
    hash = "sha256-WYHHpS721dlkWdOEj+jwJkQ/vsiP2PnmFI50M9I8sbs=";
    stripRoot = false;
  };

  vendorHash = "sha256-q2uy0YrE1D8V0EopKWJLbq2hFcjn3oyanwNJ27yyC+k=";

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
