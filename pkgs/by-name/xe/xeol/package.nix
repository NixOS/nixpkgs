{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xeol";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "xeol-io";
    repo = "xeol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZpBz3WK7fE3ofakKP24ihiSfsBUrE2m5dCfv/4PXDo=";
  };

  vendorHash = "sha256-hPWjXTxk/jRkzvLYNgVlgj0hjzfikwel1bxSqWquVhk=";

  proxyVendor = true;

  subPackages = [ "cmd/xeol/" ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.gitCommit=${finalAttrs.src.rev}"
    "-X=main.buildDate=1970-01-01T00:00:00Z"
    "-X=main.gitDescription=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Scanner for end-of-life (EOL) software and dependencies in container images, filesystems, and SBOMs";
    homepage = "https://github.com/xeol-io/xeol";
    changelog = "https://github.com/xeol-io/xeol/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xeol";
  };
})
