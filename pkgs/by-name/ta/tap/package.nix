{
  lib,
  buildGoModule,
  nix-update-script,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "tap";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "indigo";
    rev = "tap-v${finalAttrs.version}";
    hash = "sha256-nDOLIRWTyj/R0h+70+bGi85RVe2OKLNbnSaKyyqc93Q=";
  };

  vendorHash = "sha256-s1S+b+QbptqJ2mxqkvsn7M5VWfLrlwpWgRjg6lq2WVE=";

  subPackages = [
    "cmd/tap"
  ];

  postPatch = ''
    substituteInPlace cmd/tap/main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ATProtocol firehose sync utility";
    homepage = "https://github.com/bluesky-social/indigo/tree/main/cmd/tap/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      blooym
    ];
    mainProgram = "tap";
  };
})
