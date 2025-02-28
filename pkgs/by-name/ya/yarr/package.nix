{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yarr,
}:

buildGoModule rec {
  pname = "yarr";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "nkanaev";
    repo = "yarr";
    rev = "v${version}";
    hash = "sha256-ZMQ+IX8dZuxyxQhD/eWAe4bGGCVcaCeVgF+Wqs79G+k=";
  };

  vendorHash = null;

  subPackages = [ "src" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitHash=none"
  ];

  tags = [
    "sqlite_foreign_keys"
    "release"
  ];

  postInstall = ''
    mv $out/bin/{src,yarr}
  '';

  passthru.tests.version = testers.testVersion {
    package = yarr;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Yet another rss reader";
    mainProgram = "yarr";
    homepage = "https://github.com/nkanaev/yarr";
    changelog = "https://github.com/nkanaev/yarr/blob/v${version}/doc/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
