{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ulid";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "oklog";
    repo = "ulid";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Universally Unique Lexicographically Sortable Identifier (ULID) in Go";
    homepage = "https://github.com/oklog/ulid";
    changelog = "https://github.com/oklog/ulid/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ulid";
  };
}
