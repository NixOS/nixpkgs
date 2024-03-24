{ lib
, buildGoModule
, fetchFromGitHub
, testers
, risor
}:

buildGoModule rec {
  pname = "risor";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-bGlJe61B5jMb1u81NvNMJDW+dNem6bNFT7DJYno5jCk=";
  };

  proxyVendor = true;
  vendorHash = "sha256-eW6eSZp5Msg/u50i1+S2KSzDws0Rq8JBY1Yxzq7/hVo=";

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
    mainProgram = "risor";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}

