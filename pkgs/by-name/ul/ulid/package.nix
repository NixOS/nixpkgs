{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ulid";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "oklog";
    repo = "ulid";
    rev = "v${version}";
    hash = "sha256-/oQPgcO1xKbHXutxz0WPfIduShPrfH1l+7/mj8jLst8=";
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
