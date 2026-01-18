{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ulid";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "oklog";
    repo = "ulid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kPNLaZMGwGc7ngPCivf/n4Bis219yOkGAaa6mt7+yTY=";
  };

  vendorHash = "sha256-s1YkEwFxE1zpUUCgwOAl8i6/9HB2rcGG+4kqnixTit0=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    # skip flaky test
    "-skip=TestMonotonicSafe"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universally Unique Lexicographically Sortable Identifier (ULID) in Go";
    homepage = "https://github.com/oklog/ulid";
    changelog = "https://github.com/oklog/ulid/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "ulid";
  };
})
