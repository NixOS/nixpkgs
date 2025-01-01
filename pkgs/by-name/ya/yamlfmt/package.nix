{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yamlfmt,
}:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "yamlfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-l9PtVaAKjtP9apTrKCkC1KDR0IXqLqinpj1onzSrPnI=";
  };

  vendorHash = "sha256-lsNldfacBoeTPyhkjyDZhI5YR+kDke0TarfG/KdjEOg=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests.version = testers.testVersion {
    package = yamlfmt;
  };

  meta = with lib; {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    changelog = "https://github.com/google/yamlfmt/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "yamlfmt";
  };
}
