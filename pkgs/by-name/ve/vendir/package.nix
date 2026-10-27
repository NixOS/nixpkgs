{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vendir";
  version = "0.46.3";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "vendir";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Hv6ZQxOPMh8O3YFJRdwqsZRjJN8wbq8dCtSU0pqLZ9s=";
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
