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
    mainProgram = "zgrab2";
    homepage = "https://github.com/zmap/zgrab2";
    license = with lib.licenses; [
      asl20
      isc
    ];
    maintainers = with lib.maintainers; [
      fab
      juliusrickert
    ];
  };
})
