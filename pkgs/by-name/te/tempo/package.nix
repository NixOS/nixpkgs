{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tempo";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1eacaqyKyHF/uS0Ja7oq+YKn/3K2QpDmd6jysGVBOjg=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${finalAttrs.version}"
  ];

  # tests use docker
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High volume, minimal dependency trace storage";
    changelog = "https://github.com/grafana/tempo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = [ lib.maintainers.kashw2 ];
  };
})
