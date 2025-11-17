{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zgrab2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zgrab2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9YDrWtSFFzFMN/pp0Kaknie4NMduOb/ZNrP+7MIMT+0=";
  };

  vendorHash = "sha256-8oidWUtSMMm/QMzrTkH07eyyBhCeZ9SUOO1+h1evbac=";

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
