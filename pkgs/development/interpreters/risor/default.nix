{ lib
, buildGoModule
, fetchFromGitHub
, testers
, risor
}:

buildGoModule rec {
  pname = "risor";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-4Tw8QJj14MYfuQ4mNkSO1z4F8/3/6HjORKgARljlfs8=";
  };

  vendorHash = "sha256-diAbQwnlhMm43ZlLKq3llMl9mO3sIkc80aCI5UDn7F4=";

  subPackages = [
    "cmd/..."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = with lib; {
    description = "Fast and flexible scripting for Go developers and DevOps";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
