{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vendir";
  version = "0.45.2";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2qcaAuLevtP5pouFuENiKneTJs0/k7ftDaFuKjVVIow=";
  };

  vendorHash = null;

  subPackages = [ "cmd/vendir" ];

  ldflags = [
    "-X carvel.dev/vendir/pkg/vendir/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "CLI tool to vendor portions of git repos, github releases, helm charts, docker image contents, etc. declaratively";
    mainProgram = "vendir";
    homepage = "https://carvel.dev/vendir/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ russell ];
  };
})
