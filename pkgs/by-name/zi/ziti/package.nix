{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ziti";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u8OMnSUKlOiQtPtJLQrUX6M5IddDTds/77RHcAyhWeQ=";
  };

  vendorHash = "sha256-P9+trbU6lLv/jMXojI+BwQovsrBwkO+vr/pdJgdx0wo=";

  subPackages = [
    "ziti"
    "controller"
    "router"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openziti/ziti/common/version.Version=v${finalAttrs.version}"
    "-X github.com/openziti/ziti/common/version.Revision=v${finalAttrs.version}"
  ];

  meta = {
    description = "CLI for working with a Ziti deployment";
    changelog = "https://github.com/openziti/ziti/releases/tag/v${finalAttrs.version}";
    homepage = "https://openziti.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamalhabash ];
    mainProgram = "ziti";
  };
})
