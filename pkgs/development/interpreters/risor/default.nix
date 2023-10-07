{ lib
, buildGo121Module
, fetchFromGitHub
, testers
, risor
}:

buildGo121Module rec {
  pname = "risor";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-7bWtlLo1fJQ7ddcg0MFUfeCn8VNkSEENxmp0O8cNTBE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-cV6TOvcquAOr4WQ3IzWOVtLuwjQf1BA+QXzzDYnPsYQ=";

  subPackages = [
    "cmd/risor"
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

