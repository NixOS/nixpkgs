{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yamlfmt,
}:

buildGoModule (finalAttrs: {
  pname = "yamlfmt";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "yamlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G0tejPNlvtar8eR7wS8oK6//ATd9YkDlC7oa3OkzQ3c=";
  };

  vendorHash = "sha256-Cy1eBvKkQ90twxjRL2bHTk1qNFLQ22uFrOgHKmnoUIQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  # Test failure in vendored yaml package, see:
  # https://github.com/google/yamlfmt/issues/256
  checkFlags = [ "-run=!S/TestNodeRoundtrip" ];

  passthru.tests.version = testers.testVersion {
    package = yamlfmt;
  };

  meta = {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    changelog = "https://github.com/google/yamlfmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yamlfmt";
  };
})
