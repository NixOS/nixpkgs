{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zgrab2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zgrab2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rvQum+Mjpuz2XRgTY94CTqJ6Tvi78Kdd3CCMHvYZQgE=";
  };

  vendorHash = "sha256-ag2VWBNv2u/DXWWsSLBfRscm3++AjxgrGfw8JUlhnRo=";

  subPackages = [
    "cmd/zgrab2"
  ];

  meta = {
    description = "Fast Application Layer Scanner";
    homepage = "https://github.com/zmap/zgrab2";
    changelog = "https://github.com/zmap/zgrab2/releases/tag/vv${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      isc
    ];
    maintainers = with lib.maintainers; [
      fab
      juliusrickert
    ];
    mainProgram = "zgrab2";
  };
})
