{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "taproot-assets";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UFb/QOSlAVqnhK0fJmdIqythxBwFGZY1/ODTdh/hS5c=";
  };

  vendorHash = "sha256-Vvy2kXBhlMDJvSNF18X8B9CVf/GxaU2cDvChWN2aBuY=";

  subPackages = [
    "cmd/tapcli"
    "cmd/tapd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Daemon for the Taproot Assets protocol specification";
    homepage = "https://github.com/lightninglabs/taproot-assets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
