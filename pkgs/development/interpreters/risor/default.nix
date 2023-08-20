{ lib
, buildGoModule
, fetchFromGitHub
, testers
, risor
}:

buildGoModule rec {
  pname = "risor";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-QhXIwFrApSkWY2YYYGlojKsByNA2xpyVTm0SpYWB/Ds=";
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
